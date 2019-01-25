#/bin/bash

function usage(){
    cat <<Usage
Script must requires atleat one params
${0##*/}  [Options] [InputFile]
            -H Create HTML Page"
            -m Send Mail, requires to address
            -f Log file Input
            -d Debug Mode
            -h Help
Usage
}

SCRIPT_DIR=$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )

html=''
mail=''
log_file=''
while getopts 'Hm:df:h' option; do
      case "${option}" in 
            H) #Creating HTML file
                html="Components.html" ;;
            m) #Sending report in mail
                mail="${OPTARG}"  ;;
            d) #Enabling debug mode
                set -xe ;;
            f) #input file for component details
                log_file="${OPTARG}"  ;;
            h) #help
                usage
        esac
done

declare -a options=("$@")
shift $((OPTIND - 1))


if [ ! -f "${log_file}" ] ; then
    echo "Log file missing, exitting"
    exit 1
fi

if ! touch ${SCRIPT_DIR}/components.csv ; then 
    echo "Unable to create component file.. Please check you the permissions"
    exit 1
else 
    echo "Components,File" > ${SCRIPT_DIR}/components.csv
fi

#### Seprating the components by given parameters
Invalid_bits=''
for dirs in  $(cat ${log_file}  | grep -iE '.*/[a-z].+?warning'   | \
                awk -F':' '$1 ~ /\..+?[a-z]$/ {print $1}' | sort  | \
                uniq |sed 's/.* //g'| grep -v 'local') 
do
        par_dir=$(basename $(dirname $dirs)) 
        filename=$(basename $dirs)
        comp_option="${par_dir}/${filename}" 
        case $comp_option in 
	        "src/ds_list.c"|"src/ds_sl_list.c"|"src/ds_util.c" ) comp="DATA LNX" ;;
	        "src/ts_linux.c" ) comp="PROP" ;;
	        "physical/PhysicalDevice.c"|"host/spi-protocol-linux.c"|"spi/spi-host-ui.c"|"cli/network-cli.c"|"device-database/device-database-cli.c"|"reporting/reporting-cli.c"|"gateway/backchannel-support.c"|"ss1btle/L2CAP.c"|"ss1btps/L2CAP.c"|"ss1btps/L2CAP_ERTM.c") comp="Third Party" ;;
	        "wil6210/cfg80211.c"|"wireless/chan.c"|"wireless/core.c"|"wireless/nl80211.c"|"wireless/util.c") comp="WIN Ath10K" ;;
	        "armv7/cache_v7.c"|"common/scm.c"|"lib/cache-cp15.c"|"common/board_init.c"|"common/cmd_bootqca.c"|"common/cmd_runmulticore.c"|"common/cmd_sec_auth.c"|"common/fdt_fixup.c"|"ipq806x/ipq806x.c"|"i2c/qup_i2c.c"|"mmc/mmc.c"|"nand/ipq_nand.c"|"spi/spi_flash.c"|"serial/qca_uart.c"|"spi/ipq_spi.c"|"include/spi_flash.h"|"lib/fdtdec.c"|"lib/string.c"|"kconfig/conf.c"|"kconfig/mconf.c"|"src/Makefile.am"|"test/Makefile.am"|"tests/Makefile.am"|"arch-qca-common/iomap.h"|"arch-qca-common/scm.h"  ) comp="WIN CoreBSP" ;;
	        "shell/shell.c" ) comp="WIN SSDK" ;;
	        "cmd/Makefile.am" ) comp="WIN Wifi Host" ;;
	        "applets/applet_tables.c"|"applets/usage.c"|"applets/usage_pod.c"|"qdisc/nsspfifo.c"|"coreutils/stat.c"|"cxx/Makefile.am"|"calc/Makefile.am"|"expr/Makefile.am"|"demos/Makefile.am"|"examples/Makefile.am"|"linux/stddef.h"|"mk/env_post.mk"|"old/test.h"|"include/tst_test.h"|"ipq/ipq_gmac_eth.c"|"lib/Makefile.am"|"libmisc/Makefile.am"|"libspeex/Makefile.am"|"vq/Makefile.am"|"login-utils/last.c"|"login-utils/lslogins.c"|"m_debuginfo/debuginfo.c"|"da/generate_mans.mak"|"da/generate_translations.mak"|"de/generate_mans.mak"|"de/generate_translations.mak"|"fr/generate_mans.mak"|"fr/generate_translations.mak"|"man/generate_mans.mak"|"it/generate_mans.mak"|"it/generate_translations.mak"|"man/Makefile.am"|"pl/generate_mans.mak"|"pl/generate_translations.mak"|"ru/generate_mans.mak"|"ru/generate_translations.mak"|"sv/generate_mans.mak"|"sv/generate_translations.mak"|"zh_CN/generate_mans.mak"|"zh_CN/generate_translations.mak"|"miscutils/lock.c"|"mpf/Makefile.am"|"mpn/Makefile.am"|"mpq/Makefile.am"|"mpz/Makefile.am"|"networking/inetd.c"|"networking/netmsg.c"|"printf/Makefile.am"|"procps/top.c"|"rand/Makefile.am"|"qdisc/nssbf.c"|"qdisc/nsshtb.c"|"scanf/Makefile.am"|"basic/split-include.c"|"stdio/fputc.c"|"sys-utils/hwclock.h"|"cxx/Makefile.am"|"devel/Makefile.am"|"misc/Makefile.am"|"mpf/Makefile.am"|"mpn/Makefile.am"|"mpq/Makefile.am"|"mpz/Makefile.am"|"rand/Makefile.am"|"tools/sysupgrade.c"|"tune/Makefile.am"|"armemu.c"|"amrnb/Makefile.am"|"amrwb/Makefile.am"|"src/opus_decoder.c"|"src/opus_multistream_encoder.c"|"ldlang.h" ) comp="OSS" ;; 
            *) comp="OSS" ; Invalid_bits+="$comp_option " ;;
        esac
    echo "${comp},${comp_option}" >> ${SCRIPT_DIR}/components.csv
    comp_list+="<tr> <td>${comp}</td><td>${comp_option}</td></tr>"


done 

if [ -n "$mail" ] ; then 
    if [ ! -n "$html" ]; then
        html="Components.html"
    fi
fi




if [ -n "${html}" ] ; then


    function HTML(){
    cat<<Html
    <!doctype html>
    <html>
    <head>
        <title>Component Details</title>
    </head>
    	<style>
        .myTable { 
        width: 75%;
        text-align: left;
        background-color: lemonchiffon;
        border-collapse: collapse; 
        }
        .myTable th { 
        background-color: goldenrod;
        color: white; 
        }
        .myTable td, 
        .myTable th { 
        padding: 5px;
        border: 1px solid goldenrod; 
        }
        </style> 
    <body>
        <h1>Component Details</h1>
    <table >
        <tr>
            <th>Components</th>
            <th>Files</th>
        </tr>
	    ${comp_list}
    </table>
    ${blocks}
    </body>
    </html>
Html
    }


HTML > $html
fi



echo $Invalid_bits
