{% set sudoers=salt['pillar.get']('post-receive_sudo', '') %}

{% if sudoers %}

include:
  - post-receive_hook.sudoers
{% endif %}

# Get the Ropository Folder form the Git Pillar
{% set git_data=salt['pillar.get']('git_data') %}

# Get the List of Custom Hooks
{% set hook_list = salt['pillar.get']('post-receive_hooks') %}

{% for hook in hook_list %}
{% set hook_group = salt['pillar.get']('post-receive_hooks:' ~ hook ~ ':group', '') %}
{% if hook_group %}

custom_hook_{{ hook }}:
  file.managed:
    - name: {{ git_data }}{{ hook_group }}/{{ hook }}.git/custom_hooks/post-receive
    - makedirs: True
    - user: root
    - group: root
    - mode: 754
    - contents_pillar: post-receive_hooks:{{ hook }}:file

{% else %}
  Fail - no group in the post-receive_hooks [PILLAR Data]:
    test:
      A. fail_without_changes
{% endif %}

{% endfor %}
