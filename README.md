# counter-app autodeployment

Automatic deploy script to deploy the counter app for the üK 109.

## Requierements
Logged into Docker CLI (ghrc.io, Github) and logged into OpenShift via oc.

## Deploy
Modify the Github username inside ``deploy.sh``, then:
```bash
bash deploy.sh
```
You will get the route name in the output.

## Cleanup
Run:
```bash
bash cleanup.sh
```
This will clean up any changes made by ``deploy.sh``.
