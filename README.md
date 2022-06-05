# cardano-stake-pool

Setup and Manage Cardano Stake Pool

## Setup

1. CI/CD pipeline deploys [network](#network) infrastructure
2. User creates [golden install image](#golden-install-image)
3. User starts [golden synced image generator](#golden-synced-image-generator) 
5. User [deploys pool cluster](#deploy-pool-cluster)

## Manage

* New `cardano-node` version that you need to [update](#update)
* [Disaster recovery](#disaster-recovery)
* [Monitoring](#monitoring) with alerts

### Update

When a new version of `cardano-node` is released the update process is similar to [setup](#setup) with the exception of the first step which may not be needed if the network infrastructure is already deployed and did not change.

## Network

Setup as Infrastructure as Code (IaC)

* Public subnet for [Relays](#relays)
* Private subnet for [BP](#block-producer) and [Key](#key-node)
* Security groups for relay and BP
* Route table between subnets
* Ability to connect to each other on specific port
* Strict S3 bucket to hold keys?

*Need diagram
