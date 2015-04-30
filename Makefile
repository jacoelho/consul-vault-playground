
.PHONY: consul vault

consul:
	docker run -d --publish 8500:8500 --publish 53:53 --publish 53:53/udp --name consul progrium/consul -server -bootstrap -ui-dir /ui
vault:
	vault server -config=vault-example.hcl &
	export VAULT_ADDR='http://127.0.0.1:8200'
	vault init > secrets.txt
	sleep 10
	sed -n 1p secrets.txt | cut -d':' -f2| tr -d '[[:space:]]' | xargs vault unseal
	sed -n 2p secrets.txt | cut -d':' -f2| tr -d '[[:space:]]' | xargs vault unseal
	sed -n 3p secrets.txt | cut -d':' -f2| tr -d '[[:space:]]' | xargs vault unseal
	eval $$(echo export VAULT_TOKEN=$$(sed -n 6p secrets.txt | cut -d':' -f2| tr -d '[[:space:]]'))
	vault auth $$VAULT_TOKEN
	vault write secret/example/production/username value=user
	vault write secret/example/production/password value=password12345
	vault write secret/example/production/foo value=bar
