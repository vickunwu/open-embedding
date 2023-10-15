#!/bin/sh

/package/admin/s6/command/s6-svstat /run/s6-rc/servicedirs/caddy || exit 1
/package/admin/s6/command/s6-svstat /run/s6-rc/servicedirs/server || exit 1
