velero install `
    --use-node-agent `
    --provider aws `
    --plugins velero/velero-plugin-for-aws:v1.2.1 `
    --bucket velero `
    --secret-file ./credentials-velero `
    --backup-location-config region=hn,s3ForcePathStyle="true",s3Url=http://10.200.3.131 