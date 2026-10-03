#cloud-config

ssh_pwauth: false

users:
- name: localadmin
  groups: [sudo, docker]
  shell: /bin/bash
  sudo: ['ALL=(ALL) NOPASSWD:ALL']
  ssh-authorized-keys:
    - ${ssh_public_key}