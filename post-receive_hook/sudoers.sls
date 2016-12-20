  {% from "post-receive-hook/map.jinja" import sudoers_githook with context %}

  {% do sudoers_githook.update(pillar.get('post-receive_sudo', {})) %}
  # do sudoers_githook
  {% set included_files = sudoers_githook.get('included_files', {}) %}

  /etc/sudoers.d/githook:
    file.managed:
      - user: root
      - group: {{ sudoers_githook.get('group', 'root') }}
      - mode: 440
      - template: jinja
      - source: salt://post-receive-hook/files/sudoers
      - check_cmd: {{ sudoers_githook.get('exec-prefix', '/usr/sbin') }}/visudo -c -f
      - context:
          included: True
