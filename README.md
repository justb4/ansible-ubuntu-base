# ansible-ubuntu-base

Common [Ansible](https://www.ansible.com/) Roles I use to provision and secure a fresh Ubuntu server.
This used to be a lot of handwork, [Ansible](https://www.ansible.com/) is great!

Personal use but maybe worthwhile for you as well.

Inspiration/credits from/to [this article](https://www.tricksofthetrades.net/2017/08/21/ansible-playbook-server-provisioning/) 
which itself was based on articles "First N minutes on "
like [My First 10 Minutes](https://www.codelitt.com/blog/my-first-10-minutes-on-a-server-primer-for-securing-ubuntu/).
My changes were so many that it was not worthwhile to clone the GH repo.

For more advanced stuff like adding Users, Postfix Docker I use great Roles from Ansible Galaxy:

* Users, Groups, Sudoers: https://galaxy.ansible.com/sansible/users_and_groups 
* Docker and -Compose: https://galaxy.ansible.com/geerlingguy/docker
* Postfix: https://galaxy.ansible.com/oefenweb/postfix
* Python Pip: https://galaxy.ansible.com/geerlingguy/pip (Again that Geerling Guy, he's amazing!) 

Checkout my `https://github.com/justb4/ansible-ubuntu-ntp` Role as well, for installing NTP with options.

## Install

```bash

 ansible-galaxy install https://github.com/justb4/ansible-ubuntu-base
 
 # or locally in specific dir
 
 ansible-galaxy install --roles-path ./roles https://github.com/justb4/ansible-ubuntu-base


```

## Example Playbook

This sketches how I use the base-role defined here and from Galaxy in a Playbook. Mainly need to fill in
some vars and have a gmail account in this case. 

```yaml

- name: "Standard Ubuntu Server Setup"
  hosts: all
  become: true
  gather_facts: yes

  vars:
    my_email: me@somewhere.nl
    my_admin_user: my_admin_user
    pip_install_packages:
      - name: docker
    postfix_aliases:
      - user: theuser
        alias: yourgmailname@gmail.com
    postfix_relayhost: smtp.gmail.com
    postfix_relaytls: true
    postfix_smtp_tls_cafile: /etc/ssl/certs/ca-certificates.crt
    postfix_sasl_user: 'yourgmailname@gmail.com'
    postfix_sasl_password: 'your_gmail_password'
    timezone: Europe/Amsterdam
    ufw_open_ports: ['22', '80', '443']

  roles:
    # https://github.com/sansible/users_and_groups
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

    - name: ansible-ubuntu-base
      tags: ubuntu-base

    - name: ansible-ubuntu-ntp
      tags: ubuntu-ntp

    - name: oefenweb.postfix
      tags: postfix

    - name: geerlingguy.pip
      tags: pip

    # https://github.com/geerlingguy/ansible-role-docker
    - name: geerlingguy.docker
      tags: docker
      docker_users:
        - "{{ my_admin_user }}"

```

## Links

* https://www.tutorialspoint.com/ansible

## Credits

* Initial Inspiration: https://github.com/5car1z/ansible-debian-provisioning (update 2021: that repo now private or deleted?)
* [Jeff Geerling, geerlingguy](https://galaxy.ansible.com/geerlingguy) buy his book [Ansible for Devops](https://leanpub.com/ansible-for-devops) on LeanPub to support him!

