# ansible-ubuntu-base

Common [Ansible](https://www.ansible.com/) Roles I use to provision and secure a fresh Ubuntu server.
This used to be a lot of handwork, [Ansible](https://www.ansible.com/) is great!
Motto: [Box Hugger No More](https://sgillies.net/2013/07/25/box-hugger-no-more.html)!

Made for personal use but maybe worthwhile for you as well.

Inspiration/credits from/to [this article](https://www.tricksofthetrades.net/2017/08/21/ansible-playbook-server-provisioning/) 
which itself was based on articles "First N minutes on "
like [My First 10 Minutes](https://www.codelitt.com/blog/my-first-10-minutes-on-a-server-primer-for-securing-ubuntu/).
My changes were so many that it was not worthwhile to clone the GH repo.

For more advanced stuff like adding Users, Postfix Docker I use great Roles from Ansible Galaxy:

* Users, Groups, Sudoers: https://galaxy.ansible.com/sansible/users_and_groups 
* NB see [this issue](https://github.com/sansible/users_and_groups/issues/42) so for now use - src: https://github.com/justb4/ansible-users-and-groups name: justb4.users-and-groups (see below)
* Docker and -Compose: https://galaxy.ansible.com/geerlingguy/docker

Checkout my `https://github.com/justb4/ansible-ubuntu-ntp` Role as well, for installing NTP with options (Oct 2024: now integrated in `ansible-ubuntu-base`) .

## Install

Install and name it `justb4.ubuntu-base`.

```bash

 ansible-galaxy role install https://github.com/justb4/ansible-ubuntu-base,,justb4.ubuntu-base
 
 # or locally in specific dir
 
 ansible-galaxy role install --roles-path ./roles https://github.com/justb4/ansible-ubuntu-base,,justb4.ubuntu-base


```

Or with a typical `requirements.yml` file:

```
# Installs from Ansible galaxy  NO: see https://github.com/sansible/users_and_groups/issues/42
#- src: sansible.users_and_groups
#  version: v2.0.5

# NB for now use.
- src: https://github.com/justb4/ansible-users-and-groups 
  name: justb4.users-and-groups

# from GitHub
- src: https://github.com/justb4/ansible-ubuntu-base
  name: justb4.ubuntu-base
  version: v1.5

- src: geerlingguy.docker
  version: 7.4.1

```
## Example Playbook

This sketches how I use the base-role defined here and from Galaxy in a Playbook. Mainly need to fill in
some vars and have a gmail account in this case. The vars mainly override the [default vars](defaults/main.yml).

```yaml

- name: "Standard Ubuntu Server Setup"
  hosts: all
  become: true
  gather_facts: yes

  vars:
    # Set these vars to override defaults
    my_admin_user: my_admin_user
    my_email: me@realmail.com
    timezone: Europe/Amsterdam
    ufw_open_ports: ['22', '80', '443']
    # These will always be available as exported env vars
    etc_environment:
      MAIL_HOST: mymail.host.com
      MAIL_PORT: 587
      MAIL_USER: myuser
      MAIL_SENDER: mail_sender
      MAIL_PASSWORD: your_mail_pass
      OTHER: other_env_var
      
  roles:
    #  https://github.com/justb4/ansible-users-and-groups (for now)
    - name: sansible.users_and_groups
      tags: users
      sansible_users_and_groups_users:
        - name: "{{ my_admin_user }}"
          system: yes
          ssh_key: ~/.ssh/id_rsa.pub
      sansible_users_and_groups_sudoers:
         - name: "{{ my_admin_user }}"
           user: "%{{ my_admin_user }}"
           runas: "ALL=(ALL)"
           commands: "NOPASSWD: ALL"

    - name: justb4.ubuntu-base
      tags: ubuntu-base

    # https://github.com/geerlingguy/ansible-role-docker
    - name: geerlingguy.docker
      tags: docker
      docker_users:
        - "{{ my_admin_user }}"

```

## Credits

* Initial Inspiration: https://github.com/5car1z/ansible-debian-provisioning (update 2021: that repo now private or deleted?)
* [Jeff Geerling, geerlingguy](https://galaxy.ansible.com/geerlingguy) buy his book [Ansible for Devops](https://leanpub.com/ansible-for-devops) on LeanPub to support him!

## Example uses

* https://github.com/justb4/hetzner-lb/
* https://github.com/Geonovum/ogc-api-testbed
* https://github.com/justb4/ogc-api-jrc

## Links

* https://www.tutorialspoint.com/ansible


