# RHEL7CouchBase

**NOTE - this container will only work effectively on a RHEL7 based host with entitlement.
Keep this in mind - it is for RHEL7 hosts only.**


**Instructions for use**

1. Download this repo ` git clone https://github.com/bartockbat/RHEL7CouchBase.git`
2. Build the container `docker build --no-cache -t rhel71/couchbase .`
3. To run, simply `docker run -d -p 8091:8091 -p 8092:8092 rhel71/couchbase`
4. Using a web browser go to `http://<hostname>:8091` and follow the instructions for setup
