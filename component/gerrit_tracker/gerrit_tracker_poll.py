from subprocess import check_output
from gerrit_tracker_api import *
from time import sleep


def gerrit_query_poll():

    '''
    polls for the gerrit query request.
    these request are in cwd with prefix gerrit_query.
    the request are answered by gerrit_query*.html files.
    these html files are cleaned after their lifetime of 5 minutes
    by cleanup.py

    returns new gerrit query request files

    '''

    # initializing variables
    request_files_location = "./topic"
    log_file = request_files_location + "/topic.log"

    '''
    get new topic request files: find old files,
    find all files. new files = diff between old and all files
    '''

    gerrit_query_newfiles = []
    try:
        with open(log_file, "r") as fp:
            old_files = fp.read()
    except IOError:
        old_files = ""

    old_files = old_files.splitlines()

    all_files = check_output(['find', request_files_location, '-iname',
                              '*.txt'])

    all_files = all_files.splitlines()

    new_files = list(set(all_files) - set(old_files))
    print "new", new_files

    # write to a log for future reference
    with open(log_file, "a") as fp:
        for each_file in new_files:
            fp.write(each_file)
            fp.write("\n")

    return new_files

request_files_location = "./topic"
# poll for gerrit query request
new_requests = gerrit_query_poll()
for each_request in new_requests:
    print each_request
    with open(each_request, "r") as fp:
        query = fp.read().strip()
        query += "(pl:NHSS.QSDK.6.0 OR pl:NHSS.QSDK_MIPS.6.0 OR " + \
                 "pl:NHSS.QSDK.6.1 OR pl:NHSS.QSDK.9.0) status:open"
    each_request = each_request.replace(".txt", "")
    output_html_file = each_request + ".html"
    output_json_file = each_request + ".json"
    print query
    gerrit_tracker_flow(output_json_file, output_html_file, query)
    check_output(['chmod', '777', output_html_file])
output = check_output(['bash', 'cleanup.sh', request_files_location])
