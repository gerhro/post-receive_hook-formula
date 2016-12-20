# Get the Ropository Folder form the Git Pillar
{% set git_data=salt['pillar.get']('git_data') %}

# Get the List of Custom Hooks
{% set hook_list = salt['pillar.get']('post-receive_hooks') %}

{% for hook in hook_list %}
{% set group = salt['pillar.get']('post-receive_hooks:{{ hook }}:group') %}

custom_hook_{{ hook }}:
  file.managed:
    - name: {{ git_data }}{{ group }}/{{ hook }}/custom_hook/post-receive
    - makedirs: True
    - user: root
    - group: root
    - file_mode: 754
    - contents_pillar: gitlab_custom_hooks:{{ hook }}:file

{% endfor %}

{% if salt['pillar.get']('post-receive_sudo') %}
  include:
    - post-receive_hooks.sudoers
{% endif %}
