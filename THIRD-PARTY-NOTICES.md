# Third-Party Notices

This project uses third-party software and libraries. This document provides the required notices and license information.

---

## Direct Dependencies

### 1. zrok

**Copyright:** Copyright 2019 NetFoundry, Inc.
**License:** Apache License 2.0
**Project URL:** https://github.com/openziti/zrok
**Description:** Zero-trust networking platform for sharing services securely

**License Terms:**

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

**Additional Attributions:**

zrok includes code from the following third-party sources:

#### 1.1 Tailscale SOCKS5 Implementation
- **Source:** `github.com/tailscale/tailscale` (v1.58.2)
- **License:** BSD 3-Clause License
- **Used in:** `github.com/openziti/zrok/endpoints/socks`

BSD 3-Clause License

Copyright (c) Tailscale Inc.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#### 1.2 Go Standard Library WebDAV Server
- **Source:** `cs.opensource.google/go/go/`
- **License:** BSD 3-Clause License
- **Used in:** `github.com/openziti/zrok/drives/davServer`

BSD 3-Clause License

Copyright (c) 2009 The Go Authors. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of Google Inc. nor the names of its contributors may be
   used to endorse or promote products derived from this software without
   specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#### 1.3 Go WebDAV Client Library
- **Source:** `github.com/emersion/go-webdav`
- **License:** MIT License
- **Copyright:** Copyright (c) 2020 Simon Ser
- **Used in:** `github.com/openziti/zrok/drives/davClient`

MIT License

Copyright (c) 2020 Simon Ser

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

### 2. OpenZiti

**Copyright:** Copyright NetFoundry, Inc.
**License:** Apache License 2.0
**Project URL:** https://github.com/openziti/ziti
**Description:** Zero-trust networking foundation and SDK

**Attribution Notice:**

OpenZiti was developed and open sourced by NetFoundry, Inc. NetFoundry continues to fund and contribute to OpenZiti.

**License Terms:**

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

---

## Container Base Image

This add-on is built on Home Assistant base images:

**Source:** Home Assistant Docker Base Images
**License:** Apache License 2.0
**Project URL:** https://github.com/home-assistant/docker-base

---

## Build Tools and Runtime Dependencies

This project also uses the following tools and libraries at build time and runtime:

- **Alpine Linux** - MIT License and other open source licenses
- **bash** - GNU General Public License v3.0
- **curl** - MIT/X derivate license
- **jq** - MIT License
- **ca-certificates** - Mozilla Public License 2.0

---

## Full License Texts

### Apache License 2.0

The full text of the Apache License 2.0 can be found in the [LICENSE](LICENSE) file in this repository.

Online: http://www.apache.org/licenses/LICENSE-2.0

---

## Compliance Statement

This project complies with all license requirements of the third-party software it uses:

1. **Attribution:** All copyright holders are properly credited in this document
2. **License Inclusion:** License texts are included as required
3. **Notice Preservation:** All required notices have been maintained
4. **Modification Disclosure:** This is a derivative work that integrates the above components

---

## Trademarks

- "zrok" is a trademark of NetFoundry, Inc.
- "OpenZiti" is a trademark of NetFoundry, Inc.
- "Home Assistant" is a trademark of Home Assistant
- All other trademarks are the property of their respective owners

This project is not officially endorsed by or affiliated with NetFoundry, Inc. or Home Assistant, except through the use of their open source software under the applicable licenses.

---

## Updates

This third-party notices file is current as of January 2026. For the most up-to-date dependency information, please check the source repositories.

**Last Updated:** 2026-01-20
