# terra-timesketch
Terraformed Timesketch deployment in GCP for homelab/ quick proof of concept environments. 

This Terraform template and accompanying startup script will:
1. Create a GCE VM w/ extra disk for more storage
1. Install & run [Timesketch](https://timesketch.org/) collaborative timeline analysis application
1. Install [Timesketch CLI tool](https://timesketch.org/guides/user/cli-client/) 
1. Install [Plaso](https://plaso.readthedocs.io/en/latest/) tools such as [log2timeline.py](https://plaso.readthedocs.io/en/latest/sources/user/Using-log2timeline.html)
1. Attach, format and mount disk to `/mnt/disks/data/`
1. (Optionally) Copy data from GCS bucket to `~/data/` folder 


## Pre-reqs
1. Ensure [Terraform](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/install-cli) and [gcloud cli](https://cloud.google.com/sdk/docs/install) are installed and configured locally on the machine you are deploying from
1. An existing GCP project
1. A GCP service account with access to storage buckets within your project
1. (Optional) A GCS bucket for artifact storage
1. (Optional) Update the last line of `install-tools.sh` with your GCS bucket name that stores your forensic artifacts

### Assumptions
- You have a GCP firewall rule in place to only allow your home IP to access GCE instances within project
- You will handle connecting to your instance via SSH (either via SSH-in-browser or via a local terminal, etc.)

## Installation instructions 
1. Clone this repository to your local machine 
1. Review the `variables.tf` file and update the default values as desired. In particular, you will be required to update `project_id` and `service_account` to be specific to your GCP account.
1. From within the repository directory:
    ```
    terraform init
    terraform apply
    ```

## Final steps 
Here are final steps to follow before logging into Timesketch
- Validate that you can reach the instance by inputting `http://<your_gce_external_ip>` into your browser. You should see the login page.
- Create the first Timesketch user
    ```bash
    cd /opt/timesketch
    sudo docker compose exec timesketch-web tsctl create-user <USERNAME>
    ```
- (Optional) Configure the Timesketch CLI (useful for importing timelines from CLI). 
    ```bash
    timesketch config
    ```
    ```bash
    # Follow the prompts, and use the suggested parameters as shown below
    No timesketch section in the config
    What is the value for <host_uri> (URL of the Timesketch server): http://localhost
    What is the value for <auth_mode> (Authentication mode, valid choices are: "userpass" (user/pass) or "oauth"): userpass
    What is the value for <username> (The username of the Timesketch user): <USERNAME defined with tsctl create-user>
    Password for user <USERNAME> [**] 
    ```
- (Optional) Validate you can reach GCS storage bucket from your GCE instance with `gsutil ls`

## Tear-down
When you are ready to tear down your instance, run `terraform destroy`.

## Troubleshooting 
**Cannot access Timesketch login page via http**

1. Check if containers are running
    - SSH into the instance and run `sudo docker container list`. Check that you see all of the containers showing with an "Up" status. 
        - If not, it's possible something went wrong with the startup script. To review the startup script logs, enter `sudo journalctl -u google-startup-scripts.service`. Proceed with troubleshooting from there. 

2. If containers are running, you might need to create a firewall rule to allow access to your GCE instance from your external host IP.

## References
### Start up scripts on GCE
* https://cloud.google.com/compute/docs/instances/startup-scripts/linux#viewing-output
* https://www.youtube.com/watch?v=K60_VvhgcNo&t=0s

### Terraform stuff
* https://developer.hashicorp.com/terraform/language/values/locals
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address#user-project-overrides
* https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-variables
* https://developer.hashicorp.com/terraform/tutorials/configuration-language/variables

### Tool install guides
* https://timesketch.org/guides/admin/install/
* https://timesketch.org/guides/user/cli-client/
* https://plaso.readthedocs.io/en/latest/sources/user/Ubuntu-Packaged-Release.html


### Misc
* https://www.tutorialspoint.com/write-a-bash-script-that-answers-interactive-prompts