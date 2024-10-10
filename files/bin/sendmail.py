# -*- coding: utf-8 -*-
#
# Simple email prog
# ./sendmail.py just@justobjects.nl 'project meeting 3' 'is july 31 15:00 virtual conf'
#
import sys
import smtplib
import os
from pathlib import Path
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email.utils import formatdate
from email import encoders

# https://stackoverflow.com/questions/64505/sending-mail-from-python-using-smtp
# attach file: https://stackoverflow.com/questions/3362600/how-to-send-email-attachments
def send_mail(to, subject, message, files=[]):
    smtp_ssl_host = os.getenv('MAIL_HOST')
    smtp_ssl_port = int(os.getenv('MAIL_PORT'))
    username = os.getenv('MAIL_USER')
    sender = os.getenv('MAIL_SENDER')
    password = os.getenv('MAIL_PASSWORD')

    targets = [to] # ['just@justobjects.nl']

    msg = MIMEMultipart()
    msg['From'] = sender
    msg['To'] = ', '.join(targets)
    msg['Date'] = formatdate(localtime=True)
    msg['Subject'] = subject

    # Message body text
    msg.attach(MIMEText(message))

    # Optional attachments
    for path in files:
        part = MIMEBase('application', "octet-stream")
        with open(path, 'rb') as file:
            part.set_payload(file.read())
        encoders.encode_base64(part)
        part.add_header('Content-Disposition',
                        'attachment; filename="{}"'.format(Path(path).name))
        msg.attach(part)

    server = smtplib.SMTP(smtp_ssl_host, smtp_ssl_port)
    server.ehlo()
    # secure our email with tls encryption
    server.starttls()
    # re-identify ourselves as an encrypted connection
    server.ehlo()
    server.login(username, password)

    server.sendmail(sender, targets, msg.as_string())
    server.quit()


if __name__ == "__main__":
    if len(sys.argv) < 4:
        raise ValueError('Please provide email-id, subject and message and optional file path to attach')

    files = []
    if len(sys.argv) == 5 and len(sys.argv[4]) > 0:
        files = [sys.argv[4]]

    send_mail(sys.argv[1], sys.argv[2], sys.argv[3], files)
