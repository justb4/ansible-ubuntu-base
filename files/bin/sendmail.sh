#!/bin/bash
# Simple based on Python SMTP lib.
#
# If you only need to send mail e.g. from tools and scripts
# without needeing to install a mail server/program like postfix.
# Will be installed in /usr/bin as to be always available.
#
# Usage: sendmail.sh TO SUBJECT MESSAGE [OPTIONAL ATTACHMENT FILE]
# Example: sendmail.sh rudy@specials.com 'subject here' 'A message to you' '<optional filepath to attach>'
#
# Env settings required and assumed (set these in e.g. /etc/environment).
#  MAIL_HOST=mymail.host.com
#  MAIL_PORT=587
#  MAIL_USER=myuser
#  MAIL_SENDER= (may be same val as MAIL_USER)
#  MAIL_PASSWORD=thepw

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TO=$1
SUBJECT=$2
MESSAGE=$3
FILE=$4

function usage() {
    echo "Example Usage: $0 rudy@specials.com 'subject here' 'A message to you' '<optional filepath to attach>'"
    exit 1
}

[[ -z ${TO} ]] && usage
[[ -z ${SUBJECT} ]] && usage
[[ -z ${MESSAGE} ]] && usage

python3 ${DIR}/sendmail.py ${TO} "${SUBJECT}" "${MESSAGE}" "${FILE}"
