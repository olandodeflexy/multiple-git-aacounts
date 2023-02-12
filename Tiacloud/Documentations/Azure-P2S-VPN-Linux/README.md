# 1. Install the following Dependencies/Packages
```sh
sudo apt install strongswan

sudo apt install strongswan-pki

sudo apt install libstrongswan-extra-plugins

sudo apt install network-manager-strongswan

sudo apt-get install openvpn

sudo apt-get -y install network-manager-openvpn

sudo service network-manager restart
```

# 2. Install Certificates
The following steps help you generate and export certificates using the Linux CLI (strongSwan).

1. Generate the CA certificate.
```sh
ipsec pki --gen --outform pem > caKey.pem
ipsec pki --self --in caKey.pem --dn "CN=VPN CA" --ca --outform pem > caCert.pem
```

2. Print the CA certificate in base64 format. This is the format that is supported by Azure. Send the value to the Admin to Paste the certificate data into the Public certificate data field.
```sh
openssl x509 -in caCert.pem -outform der | base64 -w0 ; echo
```
# 
 <a href="#">
 <kbd>
    <img src="images/save-configuration.png" alt="Logo" width="900" height="500">
 </kbd>
 </a>

# 

```sh
# Generate the user certificate.
export PASSWORD="password"                  # change this
export USERNAME="client"                    # change this

ipsec pki --gen --outform pem > "${USERNAME}Key.pem"
ipsec pki --pub --in "${USERNAME}Key.pem" | ipsec pki --issue --cacert caCert.pem --cakey caKey.pem --dn "CN=${USERNAME}" --san "${USERNAME}" --flag clientAuth --outform pem > "${USERNAME}Cert.pem"


# Generate a p12 bundle containing the user certificate. This bundle will be used in the next steps when working with the client configuration files.

openssl pkcs12 -in "${USERNAME}Cert.pem" -inkey "${USERNAME}Key.pem" -certfile caCert.pem -export -out "${USERNAME}.p12" -password "pass:${PASSWORD}"

```

# 3. Generate VPN client configuration files

1. In the Azure portal, navigate to the virtual network gateway for the virtual network that you want to connect to.

2. On the virtual network gateway page, select Point-to-site configuration to open the Point-to-site configuration page.

3. At the top of the Point-to-site configuration page, select Download VPN client. 

# 
 <a href="#">
   <kbd>
    <img src="images/download-config.png" alt="Logo" width="900" height="500">
   </kbd>
 </a>

#

# 4. Tunnel Configuration with CLI

There are two tunnel types for P2S configuration:

1. IKEv2 Tunnel &
2. OpenVPN Tunnel

This Documentation uses OpenVPN 

```sh
# Generate a .pfx of the client key and client cert 
# NOTE: This will be the ${username}Key.pem and ${username}Cert.pem you already generated in step 2
openssl pkcs12 -export -out filename.pfx -inkey clientKey.pem -in clientCert.pem


# Extract the private key and the base64 thumbprint from the .pfx. 
openssl pkcs12 -in "filename.pfx" -nodes -out "profileinfo.txt"

# The profileinfo.txt file will contain the private key and the thumbprint for the CA, and the Client certificate. Be sure to use the thumbprint of the client certificate.

```

# 5. Edit the Downloaded Configuration Files
1. Unzip the content of the download configuration files from section 3

2. Open the profileinfo.txt in a text editor. To get the thumbprint of the client (child) certificate, select the text including and between `"-----BEGIN CERTIFICATE-----"` and `"-----END CERTIFICATE-----"` for the child certificate and copy it. You can identify the child certificate by looking at the `subject=/ line`.

3. Open the vpnconfig.ovpn file (from the unzipped files) and find the section shown below. Replace everything between `"cert"` and `"/cert"`.

```sh
# P2S client certificate
# please fill this field with a PEM formatted cert
<cert>
$CLIENTCERTIFICATE
</cert>
```

4. Open the profileinfo.txt in a text editor. To get the private key, select the text including and between `"-----BEGIN PRIVATE KEY-----"` and `"-----END PRIVATE KEY-----"` and copy it.5. Open the vpnconfig.ovpn file in a text editor and find this section. Paste the private key replacing everything between `"key"` and `"/key"`.

```sh
# P2S client root certificate private key
# please fill this field with a PEM formatted key
<key>
$PRIVATEKEY
</key>
```

# 6. Connect to the VPN 
## 6a. Using the CLI
```sh
sudo openvpn --config <name and path of your VPN profile file>&
```

## 6b. Using the GUI

1. Click + to add a new VPN connection.

2. Under Add VPN, pick Import from file….

3. Browse to the profile file and double-click or pick Open.

4. Click Add on the Add VPN window.

#
 <a href="#">
   <kbd>
    <img src="images/import.png" alt="Logo" width="900" height="500">
   </kbd>
 </a>

#

5. You can connect by turning the VPN ON on the Network Settings page, or under the network icon in the system tray.


# 7. Connect to Jump Server with Remmina Tool
- For Ubuntu, it comes with an in-built RDP tool call `Remmina`

1. To connect, open the `Remmina` tool and Click the `"Create a new connection profile"` button.

#
 <a href="#">
   <kbd>
    <img src="images/ubuntu_rdp_11.webp" alt="Logo" width="900" height="500">
   </kbd>
 </a>

#

2. Input the following details

- `Name`: Your desire name for the connection Profile
- `Server`: The IP Address of the Jump server (To be provided by your Admin)
- `User name`: Your username for the Jump server (To be provided by your Admin)
- `User password`: Your password for the Jump server (To be provided by your Admin)
- Everything else is optional
- Click `Save and Connect` to connect and also save the configuration

#
 <a href="#">
   <kbd>
    <img src="images/ubuntu_rdp_6.png" alt="Logo" width="900" height="500">
   </kbd>
 </a>

#

- You should have a running remote desktop connection established to your Jump server.

#
 <a href="#">
   <kbd>
    <img src="images/remmina_login.png" alt="Logo" width="900" height="500">
   </kbd>
 </a>

#

# Troubleshooting
1. In the entire setup process if you're prompted to use a password, use the password you exported to the terminal in section 2 (Install certificates)
