# == Class: docker
#
# Module to install an up-to-date version of Docker from the
# official PPA. The use of the PPA means this only works
# on Ubuntu.
#
# === Parameters
# [*version*]
#   The package version to install, passed to ensure.
#   Defaults to present.
#
class docker($version = undef){

  include docker::params
  $version_real = $version ? {
    undef   => $docker::params::version,
    default => $version
  }

  validate_string($version_real)
  validate_re(
    $::osfamily,
    '^Debian$',
    'This module uses PPA repos and only works with Debian based distros'
  )

  class { 'docker::install': } ->
  class { 'docker::config': } ~>
  class { 'docker::service': } ->
  Class['docker']
}
