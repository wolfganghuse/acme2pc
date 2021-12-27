# acme2pc
Helper Script to publish LetsEncrypt ACME-Certs to Nutanix PrismCentral (and PrismElement)

### Pre-Requirement: Install acme.sh

You need a working acme.sh install, find details here:
https://github.com/acmesh-official/acme.sh

```bash
curl https://get.acme.sh | sh -s email=my@example.com
```
### Install acme2pc.sh
Install acme2pc.sh from this Repo to a directory of your choice:

```bash
curl -o acme2pc.sh https://raw.githubusercontent.com/wolfganghuse/acme2pc/main/acme2pc.sh
chmod +x acme2pc.sh
```

## 1. Issue a new Certificate

**Example 1:** Single domain.

```bash
acme.sh --issue -d pc.example.com
```
**Example 2:** Single domain using DNS01 via Cloudflare.

```bash
acme.sh --issue --dns dns_cf -d pc.example.com
```

## 2. Install the Certificate using acme2pc.sh

```bash
acme.sh --install-cert --domain pc.example.com --reloadcmd "/home/centos/acme2pc.sh -h pc-ip -d pc.example.com -u pc-user -p pc-pass"
```

acme2pc.sh accepts the following Paramters:
| ENV-Parameter | CLI Flag| Details|
|---------------|---------|--------|
|DOMAIN|-d|domain (from acme.sh client)|
|PRISMCENTRAL|-h|Prism IP/Hostname|
|USERNAME|-u|Prism Username|
|PASSWORD|-p|Prism Password|

You can also create a acme2pc.env File in a .secret sub-directory (commonly used for Username/Password)
