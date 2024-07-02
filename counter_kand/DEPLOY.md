1. Auf github über Einstellungen ein Personal Access Token erstellen
1. Login mit `docker login ghcr.io`, github username als Username und das Token als Passwort eingeben
1. `docker build -t ghcr.io/<githubusername>/counter-frontend frontend` um das Frontend zu builden
1. `docker push ghcr.io/<githubusername>/counter-frontend` um das Frontend pushen
1. `docker build -t ghcr.io/<githubusername>/counter-backend backend` um das Backend zu builden
1. `docker push ghcr.io/<githubusername>/counter-backend` um das Backend zu pushen
1. Auf github die beiden Packages von «Private» auf «Public» stellen (oder ein pull-secret einrichten)

1. Deployment für das Backend mit dem Namen «counter-backend» und dem vorher erstellten image erstellen und folgende envs einrichten:
	- DB_USER aus dem counter-database secret
	- DB_NAME aus dem counter-database secret
	- DB_PASSWORD aus dem counter-database secret
	- DB_HOST aus dem counter-config configMap
	- PASSPHRASE aus dem counter-secret secret
1. Service für das Backend mit dem Namen «counter-backend» erstellen und auf den Port 8080 mappen
1. Route für das Backend erstellen

1. Deployment für das Frontend mit dem Namen «counter-frontend» und dem vorher erstellten image erstellen und folgende envs einrichten:
	- BACKEND_URL aus dem counter-config configMap
1. Service für das Frontend mit dem Namen «counter-frontend» erstellen und auf den Port 3000 mappen
1. Route für das Frontend erstellen
