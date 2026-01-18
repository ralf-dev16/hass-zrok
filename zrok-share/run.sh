#!/usr/bin/env bashio
set -e

# ==============================================================================
# zrok Share Add-on for Home Assistant
# Provides secure remote access via zrok zero-trust networking
# ==============================================================================

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

CONFIG_PATH=/data/options.json
ZROK_HOME=/data/.zrok
export HOME=/data

bashio::log.info "Starting zrok Share Add-on..."

# Read configuration
ZROK_TOKEN=$(bashio::config 'zrok_token')
BACKEND_URL=$(bashio::config 'backend_url')
BASIC_AUTH_USERNAME=$(bashio::config 'basic_auth_username')
BASIC_AUTH_PASSWORD=$(bashio::config 'basic_auth_password')
SHARE_MODE=$(bashio::config 'share_mode')
AUTO_RESTART=$(bashio::config 'auto_restart')
LOG_LEVEL=$(bashio::config 'log_level')

# Set log level
case "$LOG_LEVEL" in
    debug) bashio::log.level debug ;;
    info) bashio::log.level info ;;
    warn) bashio::log.level warning ;;
    error) bashio::log.level error ;;
esac

bashio::log.debug "Configuration loaded from $CONFIG_PATH"

# ------------------------------------------------------------------------------
# Validation
# ------------------------------------------------------------------------------

if bashio::var.is_empty "$ZROK_TOKEN"; then
    bashio::log.fatal "No zrok token configured!"
    bashio::log.fatal "Please configure your zrok invitation token in the add-on settings."
    bashio::log.fatal "Get your token from: https://zrok.io"
    exit 1
fi

if bashio::var.is_empty "$BACKEND_URL"; then
    bashio::log.fatal "No backend URL configured!"
    exit 1
fi

bashio::log.info "Backend URL: $BACKEND_URL"
bashio::log.info "Share mode: $SHARE_MODE"

# ------------------------------------------------------------------------------
# zrok Environment Setup
# ------------------------------------------------------------------------------

# Create zrok home directory if it doesn't exist
mkdir -p "$ZROK_HOME"

# Check if zrok is already enabled
if [ ! -f "$ZROK_HOME/environment.json" ]; then
    bashio::log.info "Enabling zrok for the first time..."
    bashio::log.info "This may take a few moments..."

    if ! zrok enable "$ZROK_TOKEN" 2>&1 | while IFS= read -r line; do
        bashio::log.info "$line"
    done; then
        bashio::log.fatal "Failed to enable zrok!"
        bashio::log.fatal "Please check your token and try again."
        bashio::log.fatal "Get a new token from: https://zrok.io"
        exit 1
    fi

    bashio::log.info "zrok enabled successfully!"
else
    bashio::log.info "Using existing zrok environment"
fi

# Verify zrok status
if ! zrok status &>/dev/null; then
    bashio::log.warning "zrok environment appears invalid, re-enabling..."
    rm -f "$ZROK_HOME/environment.json"

    if ! zrok enable "$ZROK_TOKEN" 2>&1 | while IFS= read -r line; do
        bashio::log.info "$line"
    done; then
        bashio::log.fatal "Failed to re-enable zrok!"
        exit 1
    fi
fi

# ------------------------------------------------------------------------------
# Build zrok share command
# ------------------------------------------------------------------------------

ZROK_CMD="zrok share public"

# Add backend URL
ZROK_CMD="$ZROK_CMD $BACKEND_URL"

# Add Basic Auth if configured
if bashio::var.has_value "$BASIC_AUTH_USERNAME" && bashio::var.has_value "$BASIC_AUTH_PASSWORD"; then
    bashio::log.info "Basic Authentication enabled for user: $BASIC_AUTH_USERNAME"
    ZROK_CMD="$ZROK_CMD --basic-auth $BASIC_AUTH_USERNAME:$BASIC_AUTH_PASSWORD"
else
    bashio::log.warning "No Basic Authentication configured - your Home Assistant will be publicly accessible!"
    bashio::log.warning "It is recommended to configure username and password for additional security."
fi

bashio::log.debug "zrok command: ${ZROK_CMD//:$BASIC_AUTH_PASSWORD/:***}"

# ------------------------------------------------------------------------------
# Start zrok share
# ------------------------------------------------------------------------------

bashio::log.info "Starting zrok share..."
bashio::log.info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Retry logic for auto-restart
RETRY_COUNT=0
MAX_RETRIES=999999  # Effectively infinite if auto_restart is enabled

while true; do
    # Start zrok share and capture output
    if $ZROK_CMD 2>&1 | while IFS= read -r line; do
        # Highlight important information
        if [[ "$line" =~ https://.* ]]; then
            bashio::log.info "🌍 Public URL: $line"
            bashio::log.info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        else
            bashio::log.info "$line"
        fi
    done; then
        # Normal exit
        bashio::log.info "zrok share stopped normally"
        break
    else
        EXIT_CODE=$?
        RETRY_COUNT=$((RETRY_COUNT + 1))

        bashio::log.error "zrok share exited with code $EXIT_CODE"

        if [ "$AUTO_RESTART" = "true" ] && [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
            WAIT_TIME=$((RETRY_COUNT * 5))
            if [ $WAIT_TIME -gt 60 ]; then
                WAIT_TIME=60
            fi

            bashio::log.warning "Auto-restart enabled, waiting ${WAIT_TIME}s before retry (attempt $RETRY_COUNT)..."
            sleep "$WAIT_TIME"

            # Check if environment is still valid
            if ! zrok status &>/dev/null; then
                bashio::log.warning "zrok environment lost, re-enabling..."
                rm -f "$ZROK_HOME/environment.json"

                if ! zrok enable "$ZROK_TOKEN" 2>&1 | while IFS= read -r line; do
                    bashio::log.info "$line"
                done; then
                    bashio::log.error "Failed to re-enable zrok, will retry..."
                    continue
                fi
            fi

            bashio::log.info "Restarting zrok share..."
        else
            bashio::log.fatal "zrok share failed and auto-restart is disabled or max retries reached"
            exit "$EXIT_CODE"
        fi
    fi
done

bashio::log.info "Add-on stopped"
