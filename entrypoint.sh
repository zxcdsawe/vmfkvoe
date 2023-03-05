#!/bin/sh

# Global variables
DIR_CONFIG="/etc/v2ray"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

uuidone=e3a7ca1c-0406-4df0-8730-28f25859dd35
uuidtwo=7c74a709-9ace-41fa-a6c7-3becf9a424f9
uuidthree=19c9da3b-4dc1-4c32-9dfa-9f46f542c7db
uuidfour=a545a52a-1a8b-4f31-9d17-6e34e2da2b2b
uuidfive=f08d0f4e-43a7-42c5-9d21-58de6f69170a
mypath=/tesnowadwe
myport=8080


# Write V2Ray configuration
cat << EOF > ${DIR_TMP}/myconfig.pb
{
	"inbounds": [
		{
			"listen": "0.0.0.0",
			"port": $myport,
			"protocol": "vless",
			"settings": {
				"decryption": "none",
				"clients": [
					{
						"id": "$uuidone"
					},
					{
						"id": "$uuidtwo"
					},
					{
						"id": "$uuidthree"
					},
					{
						"id": "$uuidfour"
					},
					{
						"id": "$uuidfive"
					}
				]
			
		},
		"streamSettings": {
			"network": "ws",
			"wsSettings": {
					"path": "$mypath"
				}
			}
		}
	],
	"outbounds": [
		{
			"protocol": "freedom"
		}
	]
}
EOF

# Get V2Ray executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o ${DIR_TMP}/v2ray_dist.zip
unzip ${DIR_TMP}/v2ray_dist.zip -d ${DIR_TMP}

# Convert to protobuf format configuration
mkdir -p ${DIR_CONFIG}
mv -f ${DIR_TMP}/myconfig.pb ${DIR_CONFIG}/myconfig.json

# Install V2Ray
install -m 755 ${DIR_TMP}/v2ray ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run V2Ray
${DIR_RUNTIME}/v2ray run -config=${DIR_CONFIG}/myconfig.json
