#/bin/sh
# commands
SENDMAIL=/usr/lib/sendmail
ECHO=/bin/echo
GZIP=/bin/gzip
CAT=/bin/cat

# attachment file info.
ATTACHED_FILE=file_name
ATTACHED_PATH=./$ATTACHED_FILE

# mail head settings.
MAIL_BODY=./mail_body.txt
MAIL_FROM=from@example.com
MAIL_TO=to@example.com
MAIL_SUBJECT="ATTACHMENT FILE TRANSFER."
MAIL_BOUNDARY=`date +%Y%m%d%H%M%N`
TIME_STAMP=`date +"%Y-%m-%d %H:%M:%S"`

for i in {1..10}
do
# make body.
$ECHO "Attached file is created at ${TIME_STAMP}" > $MAIL_BODY

# send mail.
$SENDMAIL -t << EOF
From: ${MAIL_FROM}
To: ${MAIL_TO}
Subject: ${MAIL_SUBJECT}${i}
MIME-Version: 1.0
Content-type: multipart/mixed; boundary=${MAIL_BOUNDARY}
Content-Transfer-Encoding: 7bit

--${MAIL_BOUNDARY}
Content-type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit

`${CAT} ${MAIL_BODY}`

--${MAIL_BOUNDARY}
Content-type: application/zip;
 name=${ATTACHED_FILE}
Content-Transfer-Encoding: base64
Content-Disposition : attachment;
 filename=${ATTACHED_FILE}
`${CAT} ${ATTACH_PATH} | base64`
--${MAIL_BOUNDARY}--
EOF
done
