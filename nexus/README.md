# nexus

# Initialize

```sh
sudo -E ./initialize.sh
```

Setup in browser

## Initial password

initial password: ${SONATYPE_WORK}/nexus3/admin.password


## Volumes


mkdir -p nexus-data/
chmod 775 nexus-data/
chown 200:200 nexus-data/
mkdir -p nexus-backup/
chmod 775 nexus-backup/
## References

- https://stackoverflow.com/questions/48513734/error-while-mounting-host-directory-in-nexus-docker
