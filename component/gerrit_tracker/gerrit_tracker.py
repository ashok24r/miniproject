from gerrit_tracker_api import *


def main():
    output_html_file = "gerrit_tracker.html"
    output_json_file = "gerrit_details.json"
    query = "(pl:NHSS.QSDK.6.0 OR pl:NHSS.QSDK_MIPS.6.0 OR " + \
            " pl:NHSS.QSDK.6.1 OR pl:NHSS.QSDK.9.0) status:open"
    gerrit_tracker_flow(output_json_file, output_html_file, query)

if __name__ == "__main__":
        main()
