define docker::import(
    $con_app,
    $con_user,
    $con_stage,
    $idx_srv,
    $idx_path,
    $con_id = $title
  ){

  validate_re($con_id, '^[\S]*$')
  validate_string($con_app, $con_user, $con_stage, $idx_srv, $idx_path)

  $con_img_ext = 'lxc.tar.gz'

  $img_cache = '/var/cache/lxc/docker'
  $con_uri = "${idx_srv}/${idx_path}/${con_user}/${con_app}/${con_id}.${con_img_ext}"

  exec{"fetch ${con_user}/${con_app}:${con_stage}":
    command => "curl -q -s -k -L -C - --create-dirs -o ${img_cache}/${con_id}.${con_img_ext} ${con_uri}",
    timeout => '240',
    unless  => "test -f ${img_cache}/${con_id}.${con_img_ext}",
  }

  exec{"docker import ${con_user}/${con_app}:${con_stage}":
    command => "gzip -cd ${img_cache}/${con_id}.${con_img_ext} | docker import - ${con_user}/${con_app} ${con_stage}",
    timeout => '480',
    unless  => "docker images | grep ^${con_user}/${con_app}",
    require => Exec["fetch ${con_user}/${con_app}:${con_stage}"],
  }

}
