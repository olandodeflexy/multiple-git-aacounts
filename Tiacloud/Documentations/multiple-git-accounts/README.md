
# 1. Create SSH Keys
```sh
$ ssh-keygen -t rsa -C "your_email_id_associated_with_githubPersonal_account"

# Provide the full path to the key
/home/username/.ssh/tiacloud_ssh

# Press Enter to escape the Passphrase
```

# 2. Add Keys to Github Account
```sh
cat /home/useranme/.ssh/tiacloud_ssh.pub

# paste it in your personal Tiacloud account under ssh and GPG keys
```

# 3. Create SSH config file 
```sh
touch ~/.ssh/config

# paste in the following
Host tiacloud github.com
    Hostname github.com
    IdentityFile ~/.ssh/tiacloud_ssh
    TCPKeepAlive yes
    IdentitiesOnly yes
```

# 4. Create Git Account config file
```sh
touch ~/.gitconfig

[includeIf "gitdir:TIA-CLOUD/"]
  path = .gitconfig-tiacloud

# NB: Make sure to have TIA-CLOUD directory/folder in your root or home directory
```

# 5. Create Individual Git Account credentials file
```sh
touch ~/.gitconfig-tiacloud

# paste the below: replace with your tiacloud credentials
[user]
  email = sadic.abubakari@tiacloud.co.uk
  name  = sadicabubakari
```

# 6. For Windows Users

# Update stored identities
```sh
Get-Service -Name ssh-agent | Set-Service -StartupType Manual

# Add new keys
$ ssh-add tiacloud_ssh

# Test to make sure new keys are stored:
ssh-add -l

# Test to make sure Github recognizes the keys:
ssh -T tiacloud
```

# 7. Initial Git Usage
```sh
# Use this
git clone git@github.com:tiacloudconsult/PremFina.git      

# If Error
git clone git@tiacloud:tiacloudconsult/PremFina.git      
```
