### Creating APN Certs/Keys
(historical doc)

1. Create a cert on the Apple Developer Portal
2. Open it on your computer
3. Find this cert in your local Keychain and export it in the .p12 format
4. Export its key in .p12 format as well without a password
5. The server needs to have the cert/key pair in the .pem format so run the
following to convert them (assuming the cert is cert.cer and key is key.p12):

    `openssl pkcs12 -clcerts -nokeys -in cert.p12 -out cert.pem`

    `openssl pkcs12 -nocerts -nodes -in key.p12 -out key.pem`
6. Name those keys appropriately for their environment and check them into pb.
