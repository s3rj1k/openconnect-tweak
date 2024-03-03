# openconnect-tweak

`openconnect-tweak` is an LD_PRELOAD library designed to tweak the behavior of the OpenConnect VPN client.

## Features

- Output (authentication data) of custom command in `AUTH_CMD` environment variable is fed directly into OpenConnect's stdin

## Compiling from source

```bash
git clone https://github.com/s3rj1k/openconnect-tweak.git
cd openconnect-tweak
make compile
```

## Usage

### Systemd service

```
# echo "PASSWORD" | systemd-creds --with-key=tpm2 encrypt --pretty --name=vpn-password - -

[Unit]
Description=OpenConnect VPN
After=network-online.target
Wants=network-online.target
ConditionUser=user

[Service]
Type=simple
KillMode=process
Restart=always

Environment="AUTH_CMD=/usr/bin/systemd-creds --with-key=tpm2 cat vpn-password"
Environment="LD_PRELOAD=/usr/lib/openconnect-tweak.so"

ExecStart=/usr/bin/openconnect \
        --http-auth=Basic \
        --no-dtls \
        --no-external-auth \
        --non-inter \
        --passwd-on-stdin \
        --protocol=anyconnect \
        --script-tun \
        --script="/usr/bin/ocproxy --dynfw 1080 --keepalive 60" \
        --server=https://vpn.domain.net \
        --user=user

SetCredentialEncrypted=vpn-password: \
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA \
        BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB \
        42

NoNewPrivileges=true
PrivateTmp=true
ProtectHome=tmpfs
ProtectSystem=strict

[Install]
WantedBy=default.target
```

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue to discuss potential improvements or features.

## License

`openconnect-tweak` is available under the MIT license. See the LICENSE file for more info.
