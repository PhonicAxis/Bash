#!/bin/bash
# DevToolsSecurity tool to change the authorization policies, such that a user who is a
# member of either the admin group or the _developer group does not need to enter an additional
# password to use the Apple-code-signed debugger or performance analysis tools.

/usr/sbin/DevToolsSecurity -enable

# Add all users to developer group, if they're not admins

/usr/sbin/dseditgroup -o edit -a everyone -t group _developer

# Allow any member of _developer to install Apple-provided software.
# be sure you really want to do this.

/usr/bin/security authorizationdb write system.install.apple-software authenticate-developer