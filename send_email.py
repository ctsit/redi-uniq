import sys
import json
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

if len(sys.argv) == 7:
    report_file_path = sys.argv[1]
    to_email = sys.argv[2]
    from_email = sys.argv[3]
    smtp_host = sys.argv[4]
    template_path = sys.argv[5]
    template_type = sys.argv[6]
else:
    print('6 arguments required: 1 = Path to redi-uniq generate report JSON, 2 = To email address, 3 = From email address, 4 = STMP Host, 5 = Path to email template, 6 = Report content type (html or txt)')
    exit()

def makeMimeMultipart(mime_type='alternative', subject='BlankSubject', from_email=None, to_email=None, msg_data=None):
    # Create message container - the correct MIME type is multipart/alternative.
    msg = MIMEMultipart(mime_type)
    msg['Subject'] = subject
    msg['From'] = from_email
    msg['To'] = ','.join(to_email)

    # Record the MIME types of both parts - text/plain and text/html.
    part1 = None
    part2 = None
    if msg_data['txt']:
        part1 = MIMEText(msg_data['txt'], 'plain')
    if msg_data['html']:
        part2 = MIMEText(msg_data['html'], 'html')

    # Attach parts into message container.
    # According to RFC 2046, the last part of a multipart message, in this case
    # the HTML message, is best and preferred.
    if part1:
        msg.attach(part1)

    if part2:
        msg.attach(part2)

    return msg

def sendEmail(smtp_host=None, from_email=None, to_email=None, msg=None):
    if smtp_host and from_email and to_email and msg:
        try:
            # Send the message via an SMTP server.
            s = smtplib.SMTP(smtp_host)
            # sendmail function takes 3 arguments: sender's address, recipient's address
            # and message to send - here it is sent as one string.
            s.sendmail(from_email, to_email, msg.as_string())
            s.quit()

            return True
        except Exception as e:
            tb = traceback.format_exc()
            self.last_error = tb
            return False
    else:
        self.last_error = 'No smtp host, from@, to@, or message defined'
        return False

if report_file_path and to_email and from_email and smtp_host and template_path and template_type:

    email_data = {
        'addresses': {
            'to': to_email.split(','),
            'from': from_email
        },
        'smtp_host': smtp_host,
        'mime_type': 'alternative',
        'subject_line': None
    }

    with open(report_file_path) as report_file:
        report_data = report_file.read()
        report_data = json.loads(report_data)

        email_data['subject_line'] = 'RED-I Uniq: ' + str(report_data['combined_data']['project'])

        summary_data = ''
        for form_key, form_data in report_data['combined_data']['forms'].iteritems():
            summary_data += '<tr><th class="text-right">' + str(form_key) + '</th><td>' + str(form_data['count']) + '</td></tr>\n'

    with open(template_path, 'r') as template_file:
        template_data = template_file.read()

        msg_data = {
            'txt': None,
            'html': None
        }

        replacements = {
            '_email_title_': email_data['subject_line'],
            '_project_': report_data['combined_data']['project'],
            '_date_': ','.join(report_data['combined_data']['dates']),
            '_redcap_url_': report_data['combined_data']['redcap_url'].replace('api/', ''),
            '_start_time_': report_data['combined_data']['performance']['first_run_time'],
            '_end_time_': report_data['combined_data']['performance']['last_run_time'],
            '_duration_': report_data['combined_data']['performance']['total_time'],
            '_total_subjects_': str(report_data['combined_data']['totals']['count']['total']),
            '_summary_data_': str(summary_data)
        }

        for replacement_key, replacement_data in replacements.iteritems():
            template_data = template_data.replace(replacement_key, replacement_data)

        msg_data[template_type] = template_data

        mm_message = makeMimeMultipart(email_data['mime_type'], email_data['subject_line'], email_data['addresses']['from'], email_data['addresses']['to'], msg_data)
        sendEmail(email_data['smtp_host'], email_data['addresses']['from'], email_data['addresses']['to'], mm_message)
