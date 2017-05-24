# !/bin/bash
# @author Tomasz Zięba [tomasz.zieba@pwr.wroc.pl]
# © 2014 NEKST. The WrocUT Language Technology Group G4.19. All Rights Reserved.

# Script description
# ==================

    # This script was written to speed up NLP tools installation on Ubuntu 12.04. The idea was to create one shell script installer for all NLP tools made by The WrocUT Language Technology Group G4.19.
    # This script were test on Ubuntu 12.04 LTS from official Ubuntu website (http://releases.ubuntu.com/12.04/) tens of times and worked expected way. It was tested on pure installation with the same success as on several months installation.

    # Using this script to install Question Answering module, please make sure about permissions to downloading git repository of QA. That repository isn't public, so you have to contact with member of The WrocUT Language Technology Group G4.19 to get required permissions.

    # System requirements
    # -------------------

        # Compilation of tools like Corpsu2 or Wccl is very complicated and needs big computional power. So it's highly recommend to install NLP tools on computers comply with this specification.

        # Operating system
        # ________________

            # Tools were tested on below OS (list is ordered according with G4.19 recommandation):
            #   > Ubuntu 12.04
            #   > Ubuntu 13.10

            # It's highly recommend to use 64-bit OS.

        # Processor
        # _________

            #   > 4 cores
            #   > 8 threads
            #   > ~ 3.20 GHz

        # RAM
        # ___

            #   > 4 GB

        # Hard disk space
        # _______________

            #   > 5 GB for NLP tools
            #   > 500 GB for big data linked with NLP tools

    # NLP tools descirption
    # ---------------------

        # NLP tools possible to install:
        #   > corpus2     (http://www.nlp.pwr.wroc.pl/redmine/projects/corpus2/wiki)
        #   > toki        (http://www.nlp.pwr.wroc.pl/redmine/projects/toki/wiki)
        #   > maca        (http://www.nlp.pwr.wroc.pl/redmine/projects/libpltagger/wiki)
        #   > wccl        (http://www.nlp.pwr.wroc.pl/redmine/projects/joskipi/wiki)
        #   > wcrft       (http://www.nlp.pwr.wroc.pl/redmine/projects/wcrft/wiki)
        #   > iobber      (http://www.nlp.pwr.wroc.pl/redmine/projects/iobber/wiki)
        #   > solr        (http://lucene.apache.org/solr/)
        #   > ner-ws      (http://www.nlp.pwr.wroc.pl/redmine/projects/ner-ws/wiki)
        #   > qa          (http://www.nlp.pwr.wroc.pl/redmine/projects/qa/wiki/Instalacja_prototypu#Instalacja-wymaganych-modułów)

    # Parameters description
    # ----------------------

        # Script parameters setting on start (command line level):
        #   > p - path to NLP tools repositories folder (default: ~/nlp-tools/)
        #   > r - domain or ip of NLP tools repository (default: nlp.pwr.wroc.pl)
        #   > d - path to big data directory (eg. QA documents, solr collections, databases dumps) (default: '')
        #   > h - ip of installed tools remote server (default: localhost)
        #   > N - name of Ner-ws database (default: nerws)
        #   > U - name of Ner-ws database user (default: BorsukG419)
        #   > P - user password for Ner-ws database (default: BorsukNekst)

    # Start commands examples
    # -----------------------

        # Parameters could be set in any order without difference for script processing.

        # Default parameters
        # __________________

            # >>> bash ubuntu-12.04.sh <<<

        # Defined parameters
        # __________________

            # >>> bash ubuntu-12.04.sh -p /home/xxx/nlp-tools/ -r nlp.pwr.wroc.pl -d /home/xxx/big_data/ -h localhost -N nerws -U BorsukG419 -P BorsukNekst<<<

# Script functional methods
# =========================

    # Script communicates
    # -------------------

        # Section with communicates functions, which ensure formatting text, shows it and exited from script if it is necessary.

        # Function confirmed
        # __________________

            # Function is calling when script confirmed user input.
            # Function prints message given as parameter with INTERACTION label in cyan color [code number for cyan color: 36]

            # Parameters description
            # **********************

                #   > $1 - message to print with confirmation formatting

            # Function definition
            # *******************

                confirmed()
                {
                    echo -e "\e[7;36mINTERACTION\e[0m \e[3;36m  $1\n\e[0m" >&2
                }

        # Function error
        # ______________

            # Function is calling when an error occurred. It show communicate given in parameter and exits script.
            # Function prints message given as parameter with ERROR label in red color [code number for red color: 31]

            # Parameters description
            # **********************

                #   > $1 - message to print with error formatting

            # Function definition
            # *******************

                error ()
                {
                    echo  -e "\e[7;31mERROR\e[0m \e[1;31m$1 Script exit now.\e[0m" >&2
                    exit 1
                }

        # Function info
        # _____________

            # Function is calling when communicate to user is need to be shown.
            # Function prints message given as parameter with INFORMATION label in yellow color [code number for yellow color: 33]

            # Parameters description
            # **********************

                #   > $1 - message to print with information formatting

            # Function definition
            # *******************

                info()
                {
                    echo -e "\e[7;33mINFORMATION\e[0m \e[3;33m$1\e[0m" >&2
                }

        # Function passed
        # _______________

            # Function is calling when module passed it's tests.
            # Function prints message given as parameter with PASSED label in blue color [code number for blue color: 34]

            # Parameters description
            # **********************

                #   > $1 - message to print with passed formatting

            # Function definition
            # *******************

                passed()
                {
                    echo -e "\e[7;34mPASSED \e[0m \e[3;34m$1\e[0m" >&2
                }

        # Function success
        # ________________

            # Function is calling when part of data was successfully installed.
            # Function prints message given as parameter with SUCCESS label in green color [code number for green color: 32]

            # Parameters description
            # **********************

                #   > $1 - message to print with success formatting

            # Function definition
            # *******************

                success()
                {
                    echo -e "\e[7;32mSUCCESS\e[0m \e[3;32m$1\e[0m" >&2
                }

    # Catalog methods
    # ---------------

        # Function remove_directory
        # _________________________

            # Function removes directory if exists.
            # If removing directory failed, function shows error communicate and exits script;

            # Parameters description
            # **********************

                #   > $1 - name or path to removing directory

            # Function definition
            # *******************

                remove_directory()
                {
                    if [ -d $1 ]; then
                        if [ -L $1 ]; then
                             rm $1
                        else
                             rm -r $1
                        fi
                    fi
                }

        # Function create_directory
        # _________________________

            # Function creates directory with given name.
            # If creating directory failed, function shows error communicate and exits script;

            # Parameters description
            # **********************

                #   > $1 - name or path to creating directory

            # Function definition
            # *******************

                create_directory()
                {
                    # try go to directory

                    cd $1

                    if [ "$?" != "0" ]; then
                        # if directory does not exist, create it

                        mkdir -p $1

                        if [ "$?" = "0" ]; then
                            # then go to the directory

                            cd $1
                        else
                             mkdir -p $1
                             chmod 777 $1

                            if [ "$?" = "0" ]; then
                                # then go to the directory

                                cd $1
                            else
                                error "Cannot find nor create directory: $1."
                            fi
                        fi
                    fi
                }

# Script parameters
# ==================

    # Default values
    # --------------

        # DEFAULT_FULL_PATH
        # _________________

            # default path to directory existed, where NLP tools repositories will be stored

            DEFAULT_FULL_PATH='/home/'$(whoami)'/nlp-tools/'

        # DEFAULT_DATA_PATH
        # _________________

            # default path to directory existed, where big data (eg. QA documents, solr collections, databases dumps) is store or will be stored

            DEFAULT_DATA_PATH='/home/'$(whoami)'/data/'

        # DEFAULT_REPOSITORY
        # __________________
    
            # default address domain to NLP tools repository

            DEFAULT_REPOSITORY='nlp.pwr.wroc.pl'

        # DEFAULT_HOST
        # ____________

            # default ip address to host computer

            DEFAULT_HOST='localhost'

        # DEFAULT_NERWS_DB_NAME
        # _____________________

            # default name of Ner-ws database

            DEFAULT_NERWS_DB_NAME="nerws"

        # DEFAULT_NERWS_DB_USER
        # _____________________

            # default user name of Ner-ws database

            DEFAULT_NERWS_DB_USER="BorsukG419"

        # DEFAULT_NERWS_DB_PASS
        # _____________________

            # default user password of Ner-ws database

            DEFAULT_NERWS_DB_PASS="BorsukNekst"

    # Initialization
    # --------------

        # look for parameters values defined by user and assing them

        while getopts ":p:r:d:h:N:U:P:" opt; do
            case $opt in
                p)
                    FULL_PATH="$OPTARG" ;;
                r)
                    REPOSITORY="$OPTARG" ;;
                d)
                    DATA_PATH="$OPTARG" ;;
                h)
                    HOST="$OPTARG" ;;
                N)
                    NERWS_DB_NAME="$OPTARG" ;;
                U)
                    NERWS_DB_USER="$OPTARG" ;;
                P)
                    NERWS_DB_PASS="$OPTARG" ;;
                \?)
                    error "Option '-$OPTARG' is incorrect."
                    exit 1 ;;
                :)
                    error "Option '-$OPTARG' requires an argument."
                    exit 1 ;;
            esac
        done

    # Validation
    # ----------

        # if parameter was not initialize, assign its default value

        # DATA_PATH parameter
        # ___________________

            # check initialization

            if [ -z $DATA_PATH ] ; then
                DATA_PATH="$DEFAULT_DATA_PATH"
            fi

            # ensure slash at the end of the path

            if [[ $DATA_PATH != */ ]] ; then
                DATA_PATH="$DATA_PATH/"
            fi

            create_directory $DATA_PATH

        # FULL_PATH parameter
        # ___________________

            # check initialization

            if [ -z $FULL_PATH ] ; then
                FULL_PATH="$DEFAULT_FULL_PATH"
            fi

            # ensure slash at the end of the path

            if [[ $FULL_PATH != */ ]] ; then
                FULL_PATH="$FULL_PATH/"
            fi

            create_directory $FULL_PATH

        # HOST parameter
        # ______________

            # check initialization

            if [ -z $HOST ] ; then
                HOST="$DEFAULT_HOST"
            fi

        # REPOSITORY parameter
        # ____________________

            # check initialization

            if [ -z $REPOSITORY ] ; then
                REPOSITORY="$DEFAULT_REPOSITORY"
            fi

    # User confirmation
    # -----------------

        # print message on screen to show values of script parameters before installation processing

        info "Parameter values:\nhost:\t\t\t$HOST\ndata path:\t\t$DATA_PATH\nNLP tools path:\t\t$FULL_PATH\ngit repository:\t\t$REPOSITORY\nNer-ws database name:\t$NERWS_DB_NAME\nNer-ws database user:\t$NERWS_DB_USER\nNer-ws user password:\t$NERWS_DB_PASS\n\nPress [Enter] key to choose NLP tools to install..."

        # pause script and wait for user acceptiation (by clicking [Enter] key)

        read 

        confirmed "Installation parameters were confirmed."

    # NLP tools selection
    # -------------------

        # print message on screen to allow user choose right NLP tools to install

        info "Choose one of below numbers to install right NLP tool(s):\n1: corpus2\n2: corpus2 + toki\n3: corpus2 + toki + maca\n4: corpus2 + toki + maca + wccl\n5: corpus2 + toki + maca + wccl + wcrft\n6: corpus2 + toki + maca + wccl + wcrft + iobber\n7: corpus2 + toki + maca + wccl + wcrft + iobber + qa\n8: corpus2 + toki + maca + wccl + wcrft + iobber + solr + ner-ws + qa"

        # read number of user selected version of set with NLP tools to install

        #read TOOLS_SET_VERSION_NUMBER

        # set number of NLP tools to install equal with user typed number

        TOOLS_TO_INSTALL=$TOOLS_SET_VERSION_NUMBER

        # if read value is not an exact number - program will stop, else program show success message and start installation

        if [[ ! ($TOOLS_SET_VERSION_NUMBER =~ ^[1-8]$) ]]; then 
            error "Entered value is not matched with any number of set with NLP tools."
        else
            confirmed "Script will install each NLP tool from set with number $TOOLS_SET_VERSION_NUMBER on your computer."
        fi

# Script constant values
# ======================

    # System paths
    # ------------

        # Specific directories names
        # __________________________

            # SOLR_DIRECTORY_NAME
            # *******************

                # nome of Solr directory

                SOLR_DIRECTORY_NAME="solr-4.8.1"

            # CRFPP_DIRECTORY_NAME
            # ********************

                # name of CRF++ directory

                CRFPP_DIRECTORY_NAME="CRF++-0.58"

            # LINER_CRFPP_DIRECTORY_NAME
            # **************************

                # name of Liner required CRF++ 0.57 directory

                LINER_CRFPP_DIRECTORY_NAME="CRF++-0.57"

            # LINER_MODEL_DIRECTORY_NAME
            # **************************

                # name of Liner model directory

                LINER_MODEL_DIRECTORY_NAME="liner2-model"

        # Repository directories
        # ______________________

            # CORPUS2_PATH
            # ************

                # path to Corpus2 repository on computer

                CORPUS2_PATH=$FULL_PATH"corpus2/"

            # TOKI_PATH
            # *********

                # path to Toki repository on computer

                TOKI_PATH=$FULL_PATH"toki/"

            # MACA_PATH
            # *********

                # path to Maca repository on computer

                MACA_PATH=$FULL_PATH"maca/"

            # WCCL_PATH
            # *********

                # path to Wccl repository on computer

                WCCL_PATH=$FULL_PATH"wccl/"

            # CRFPP_PATH
            # **********

                # path to CRF++ repository

                CRFPP_PATH=$FULL_PATH"crf++/"

            # WCRFT_PATH
            # **********

                # path to Wcrft repository on computer

                WCRFT_PATH=$FULL_PATH"wcrft/"

            # NKJP_CORPUS_MODEL_PATH
            # **********************

                # path to NKJP corpus downloaded archive package

                NKJP_CORPUS_MODEL_PATH=$FULL_PATH"corpus_nkjp/"

            # IOBBER_PATH
            # ***********

                # path to Iobber repository on computer

                IOBBER_PATH=$FULL_PATH"iobber/"

            # QA_PATH
            # *******

                # path to QA repository on computer

                QA_PATH=$FULL_PATH"qa/"

            # PYPLWN_PATH
            # ***********

                # patho to PYPLWN repository on computer

                PYPLWN_PATH=$QA_PATH"scripts/installers/pyplwn/"

            # MALTPARSER_PATH
            # ***************

                # path to Maltparser directory on computer

                MALTPARSER_PATH=$FULL_PATH"maltparser/"

            # SOLR_PATH
            # *********

                # path to Solr directory on computer

                SOLR_PATH=$DATA_PATH"solr/"

            # LINER_PATH
            # **********

                # path to Liner directory on computer

                LINER_PATH=$FULL_PATH"liner2/"

            # LINER_LIBRARY_PATH
            # ******************

                # path to Liner library directory on computer

                LINER_LIBRARY_PATH=$LINER_PATH"lib/"

            # LINER_MODEL_PATH
            # ****************

                # path to Liner model on computer

                LINER_MODEL_PATH=$LINER_PATH"model/"

            # LINER_CRFPP_JAVA_PATH
            # *********************

                # path to Liner required CRF++ 0.57 java files

                LINER_CRFPP_JAVA_PATH=$LINER_LIBRARY_PATH$LINER_CRFPP_DIRECTORY_NAME"/java/"

            # NERWS_PATH
            # **********

                # path to Ner-ws directory on computer

                NERWS_PATH=$FULL_PATH"ner-ws/"

            # NERWS_PUBLIC_HTML_PATH
            # **********************

                # path to Ner-ws public html directory on computer

                NERWS_PUBLIC_HTML_PATH=$NERWS_PATH"public_html/"

            # NERWS_WS_PATH
            # *************

                # path to Ner-ws ws directory on computer

                NERWS_WS_PATH=$NERWS_PUBLIC_HTML_PATH"ws/"

            # NERWS_SHARED_PATH
            # *****************

                # path to Ner-ws public shared components directory on computer

                NERWS_SHARED_PATH=$DATA_PATH"nerws/"

            # NERWS_SHARED_WS_PATH
            # ********************

                # path to Ner-ws public shared components ws part on computer

                NERWS_SHARED_WS_PATH=$NERWS_SHARED_PATH"ws/"

        # Specific directories
        # ____________________

            # APACHE_CONFIGS_DIRECTORY
            # ************************

                # directory with Apache configuration files

                APACHE_CONFIGS_DIRECTORY="/etc/apache2/sites-available/"

            # WCCL_RULES_TEMPORARY_DIRECTORY
            # ******************************

                # directory with temporary Wccl rules files

                WCCL_RULES_TEMPORARY_DIRECTORY="/tmp/wcclrules/"

            # NKJP_CORPUS_MODEL_SYSTEM_DIRECTORY
            # **********************************

                # installation path of NKJP corpus

                NKJP_CORPUS_MODEL_SYSTEM_DIRECTORY="/usr/local/lib/python2.7/dist-packages/wcrft-1.0.0-py2.7.egg/wcrft/model"

            # QA_CONFIGURATION_DIRECTORY
            # **************************

                # directory with QA configuration files

                QA_CONFIGURATION_DIRECTORY=$QA_PATH"questionanswering/app_configs/"

            # QA_MALTPARSER_DIRECTORY
            # ***********************

                # default path to QA maltparser data

                QA_MALTPARSER_DIRECTORY=$QA_PATH"questionanswering/data/maltparser"

            # INIT_DIRECTORY
            # **************

                # directory for script starting Solr

                INIT_DIRECTORY="/etc/init.d/"

            # PYTHON_BUILD_DIRECTORY
            # **********************

                # path to default python build directory

                PYTHON_BUILD_DIRECTORY="/home/"$(whoami)"/build"

            # MALTPARSER_DIRECTORY_NAME
            # *************************

                # name of MaltParser directory

                MALTPARSER_DIRECTORY_NAME=$FULL_PATH"maltparser-1.7.2/"

            # NERWS_LOG_DIRECTORY
            # *******************

                # name of directory with Ner-ws log file

                NERWS_LOG_DIRECTORY=$NERWS_WS_PATH"logs/"

        # Configuration files
        # ___________________

            # APACHE_CONFIGURATION_FILE
            # *************************

                # path to apache name configuration file

                APACHE_CONFIGURATION_FILE="/etc/apache2/conf.d/name"

            # SOLR_APACHE_CONFIGURATION_FILE_NAME
            # ***********************************

                # name of apache server configuration file for Solr

                SOLR_APACHE_CONFIGURATION_FILE_NAME="solr"

            # SOLR_APACHE_CONFIGURATION_FILE
            # ******************************

                # system path to Solr configuration file for Apache

                SOLR_APACHE_CONFIGURATION_FILE=$APACHE_CONFIGS_DIRECTORY$SOLR_APACHE_CONFIGURATION_FILE_NAME

            # QA_DEFAULT_CONFIGURATION_FILE
            # *****************************

                # file with default QA configuration

                QA_DEFAULT_CONFIGURATION_FILE=$QA_CONFIGURATION_DIRECTORY"tool_config.ini"

            # QA_LOCAL_CONFIGURATION_FILE
            # ***************************

                # file with local QA configuration

                QA_LOCAL_CONFIGURATION_FILE=$QA_CONFIGURATION_DIRECTORY"tool_config.local.ini"

            # NERWS_APACHE_CONFIGURATION_FILE_NAME
            # ************************************

                # name of apache server configuration file for Ner-ws

                NERWS_APACHE_CONFIGURATION_FILE_NAME="nerws"

            # NERWS_APACHE_CONFIGURATION_FILE
            # *******************************

                # system path to Solr configuration file for Apache

                NERWS_APACHE_CONFIGURATION_FILE=$APACHE_CONFIGS_DIRECTORY$NERWS_APACHE_CONFIGURATION_FILE_NAME

            # NERWS_LOG_CONFIG_FILE_NAME
            # **************************

                # name of Ner-ws configuration log file

                NERWS_LOG_CONFIG_FILE_NAME="log.php"

            # NERWS_LOG_CONFIG_FILE_PATH
            # **************************

                # path to Ner-ws configuration log file

                NERWS_LOG_CONFIG_FILE_PATH=$NERWS_WS_PATH$NERWS_LOG_CONFIG_FILE_NAME

            # NERWS_CONFIG_FILE_NAME
            # **********************

                # name of Ner-ws configuration file

                NERWS_CONFIG_FILE_NAME="config.php"

            # NERWS_CONFIG_FILE_PATH
            # **********************

                # path to Ner-ws configuration file

                NERWS_CONFIG_FILE_PATH=$NERWS_WS_PATH$NERWS_CONFIG_FILE_NAME

            # NERWS_WSDL_FILE_NAME
            # ********************

                # name of Ner-ws WSDL file

                NERWS_WSDL_FILE_NAME="nerws.wsdl"

            # NERWS_WSDL_FILE_PATH
            # ********************

                # path to Ner-ws WSDL file

                NERWS_WSDL_FILE_PATH=$NERWS_WS_PATH$NERWS_WSDL_FILE_NAME

            # NERWS_LOG_FILE_PATH
            # *******************

                # path to Ner-ws log file

                NERWS_LOG_FILE_PATH=$NERWS_LOG_DIRECTORY"log.txt"

        # Application start files
        # _______________________

            # MALTPARSER_START_JAR
            # ********************

                # path to JAR library starting Maltparser

                MALTPARSER_START_JAR=$MALTPARSER_PATH"maltparser.jar"

            # SOLR_STARTUP_SCRIPT_NAME
            # ************************

                # script starting Solr

                SOLR_STARTUP_SCRIPT_NAME="zzz_solr"

            # SOLR_STARTUP_SCRIPT
            # *******************

                # system path to script starting Solr

                SOLR_STARTUP_SCRIPT=$INIT_DIRECTORY$SOLR_STARTUP_SCRIPT_NAME

            # LINER_STARTUP_SCRIPT_NAME
            # *************************

                # script starting Liner

                LINER_STARTUP_SCRIPT_NAME="zzz_liner"

            # LINER_STARTUP_SCRIPT
            # ********************

                # system path to script starting Liner

                LINER_STARTUP_SCRIPT=$INIT_DIRECTORY$LINER_STARTUP_SCRIPT_NAME

        # Specific files
        # ______________

            # MALTPARSER_APPLICATION_START_FILE
            # *********************************

                # path to MaltParser application start file

                MALTPARSER_APPLICATION_START_FILE="maltparser-1.7.2.jar"

            # MORFEUSZ_SGJP_REPOSITORY_SOURCE_FILE
            # ************************************

                # path to apt repository entry of Morfeusz SGJP

                MORFEUSZ_SGJP_REPOSITORY_SOURCE_FILE="/etc/apt/sources.list.d/bartosz-zaborowski-nlp-precise.list"

            # LINER_LIBRARY_SO
            # ****************

                # Liner library

                LINER_LIBRARY_SO="libCRFPP.so"

            # LINER_LIBRARY_JAR
            # *****************

                # Liner library

                LINER_LIBRARY_JAR="CRFPP.jar"

            # NERWS_DATABASE_DUMP_FILE_PATH
            # *****************************

                # path to Ner-ws database dump file

                NERWS_DATABASE_DUMP_FILE_PATH=$NERWS_PATH"database/liner2_create.sql"

    # Packages names
    # --------------

        # CRFPP_PACKAGE_NAME
        # __________________

            # name of CRF++ installation package

            CRFPP_PACKAGE_NAME=$CRFPP_DIRECTORY_NAME".tar.gz"

        # NKJP_CORPUS_PACKAGE_NAME
        # ________________________

            # name of NKJP corpus installation package

            NKJP_CORPUS_PACKAGE_NAME="model_nkjp10_wcrft_s2.7z"

        # MALTPARSER_PACKAGE_NAME
        # _______________________

            # name of Maltparser package

            MALTPARSER_PACKAGE_NAME="maltparser-1.7.2.tar.gz"

        # SOLR_PACKAGE_NAME
        # _________________

            # name of Solr package

            SOLR_PACKAGE_NAME=$SOLR_DIRECTORY_NAME".tgz"

        # LINER_CRFPP_PACKAGE_NAME
        # ________________________

            # name of Liner required CRF++ 0.57 package

            LINER_CRFPP_PACKAGE_NAME=$LINER_CRFPP_DIRECTORY_NAME".tar.gz"

        # LINER_MODEL_PACKAGE_NAME
        # ________________________

            # name of Liner model package

            LINER_MODEL_PACKAGE_NAME=$LINER_MODEL_DIRECTORY_NAME".tar.gz"

    # Download links
    # --------------

        # CRFPP_DOWNLOAD_LINK
        # ___________________

            # link to installation package of CFR ++

            CRFPP_DOWNLOAD_LINK="https://crfpp.googlecode.com/files/CRF%2B%2B-0.58.tar.gz"

        # NKJP_CORPUS_DOWNLOAD_LINK
        # _________________________

            # link to installation package of NKJP corpus

            NKJP_CORPUS_DOWNLOAD_LINK="http://156.17.134.43/share/wcrft/model_nkjp10_wcrft_s2.7z"

        # MALTPARSER_DOWNLOAD_LINK
        # ________________________

            # link to maltparser package

            MALTPARSER_DOWNLOAD_LINK="http://maltparser.org/dist/"$MALTPARSER_PACKAGE_NAME

        # SOLR_DOWNLOAD_LINK
        # __________________

            # link to installation package of Solr

            SOLR_DOWNLOAD_LINK="http://ftp.ps.pl/pub/apache/lucene/solr/4.8.1/"$SOLR_PACKAGE_NAME

        # LINER_MODEL_DOWNLOAD_LINK
        # _________________________

            # link to download package of Liner

            LINER_MODEL_DOWNLOAD_LINK="http://156.17.134.51/packages/Data%20sets/"$LINER_MODEL_PACKAGE_NAME

    # Git commands
    # ------------

        # GIT_PUBLIC_REPOSITORY_DOWNLOAD_COMMAND
        # ______________________________________

            # this command is used to download NLP tools public repositories using git
            # name of the repository should be added at the end of the constant before processing command
            # eg. "$GIT_PUBLIC_REPOSITORY_DOWNLOAD_COMMANDcorpus2.git"

            GIT_PUBLIC_REPOSITORY_DOWNLOAD_COMMAND="git clone http://$REPOSITORY/"

        # GIT_PRIVATE_REPOSITORY_DOWNLOAD_COMMAND
        # _______________________________________

            # this command is used to download NLP tools private repositories using git
            # name of the repository should be added at the end of the constant before processing command
            # eg. "$GIT_PRIVATE_REPOSITORY_DOWNLOAD_COMMANDqa"

            GIT_PRIVATE_REPOSITORY_DOWNLOAD_COMMAND="git clone git@$REPOSITORY:"

        # GIT_SWITCH_BRANCH
        # _________________

            # this command is used to switch git branch in repository

            GIT_SWITCH_BRANCH="git checkout "

    # Constant values
    # ---------------

        # ZERO
        # ____

            # variable with 0 value

            ZERO=0

    # Static string values
    # --------------------

        # APACHE_CONFIGURATION_STRING
        # ___________________________

            # string to register ServerName of Apache in name configuration file

            APACHE_CONFIGURATION_STRING='echo "ServerName localhost" >> '$APACHE_CONFIGURATION_FILE

        # SOLR_CONFIGURATION_ALLOW
        # ________________________

            # section 'allow' of Solr configuration file for Apache

            SOLR_CONFIGURATION_ALLOW="    Allow from all"

        # SOLR_CONFIGURATION_OPTIONS
        # __________________________

            # section 'options' of Solr configuration file for Apache

            SOLR_CONFIGURATION_OPTIONS="    Options FollowSymLinks Indexes"

        # SOLR_CONFIGURATION_ORDER
        # ________________________

            # section 'order' of Solr configuration file for Apache

            SOLR_CONFIGURATION_ORDER="    Order deny,allow"

# Script functional methods
# =========================

    # Installation methods
    # --------------------

        # Function make_install
        # _____________________

            # Function installing tool from current folder with make install.

            # Parameters description
            # **********************

                #   > $1 - module name

            # Function definition
            # *******************

                make_install()
                {
                     make install

                    if [ "$?" = "0" ]; then
                         ldconfig

                        if [ "$?" != "0" ]; then
                            error "System reloading command ended with errors."
                        fi
                    else
                        error "$1 installation failed."
                    fi
                }

        # Function python_install
        # _______________________

            # Function installing tool from current folder with python install.

            # Parameters description
            # **********************

                #   > $1 - module name

            # Function definition
            # *******************

                python_install()
                {
                     python setup.py install

                    if [ "$?" = "0" ]; then
                        info "$1 was successfully installed."
                    else
                        error "$1 installation failed."
                    fi
                }

        # Function aptget_update
        # ______________________

            # Function updating system packages with apt-get.

            # Parameters description
            # **********************

                # Function has no parameters.

            # Function definition
            # *******************

                aptget_update()
                {
                     apt-get update -y

                    if [ "$?" != "0" ]; then
                        error "System programs updating unexpectively ended with error."
                    fi
                }

        # Function aptget_upgrade
        # _______________________

            # Function upgrading system packages with apt-get.

            # Parameters description
            # **********************

                # Function has no parameters.

            # Function definition
            # *******************

                aptget_upgrade()
                {
                     apt-get upgrade -y

                    if [ "$?" != "0" ]; then
                        error "System programs upgrading unexpectively ended with error."
                    fi
                }

        # Function aptget_autoclean
        # _________________________

            # Function cleaning system packages with apt-get.

            # Parameters description
            # **********************

                # Function has no parameters.

            # Function definition
            # *******************

                aptget_autoclean()
                {
                     apt-get autoclean

                    if [ "$?" != "0" ]; then
                        error "System programs cleaning unexpectively ended with error."
                    fi
                }

        # Function aptget_autoremove
        # __________________________

            # Function removing system packages with apt-get.

            # Parameters description
            # **********************

                # Function has no parameters.

            # Function definition
            # *******************

                aptget_autoremove()
                {
                     apt-get autoremove

                    if [ "$?" != "0" ]; then
                        error "System programs removing unexpectively ended with error."
                    fi
                }

    # Testing methods
    # ---------------

        # Function test_import
        # ____________________

            # Function testing import of NLP tools after installation.

            # Parameters description
            # **********************

                #   > $1 - module name
                #   > $2 - python module name of NLP tool

            # Function definition
            # *******************

                test_import()
                {
                    if ! $(python -c "import $2" &> /dev/null); then
                        error "Import test for $1 module failed."
                    else
                        passed "$1 module passed import test."
                    fi
                }

        # Function test_analyse
        # _____________________

            # Function testing analyse process of NLP tools after installation.

            # Parameters description
            # **********************

                #   > $1 - module name
                #   > $2 - analysis command

            # Function definition
            # *******************

                test_analyse()
                {
                    echo "$1 installation test." | $2

                    if [ "$?" != "0" ]; then
                        error "Analysis test for $1 module failed."
                    fi

                    passed "$1 module passed analysis test."
                }

    # Git methods
    # -----------

        # Function download_public_git_repository
        # _______________________________________

            # Function downloading public git repository with given name.

            # Parameters description
            # **********************

                #   > $1 - module name
                #   > $2 - repository name
                #   > $3 - module path

            # Function definition
            # *******************

                download_public_git_repository()
                {
                    cd $FULL_PATH
                    remove_directory $3

                    # download Corpus2 git repository

                    $GIT_PUBLIC_REPOSITORY_DOWNLOAD_COMMAND"$2.git"

                    if [ "$?" != "0" ]; then
                        error "$1 downloading failed."
                    fi
                }

        # Function download_private_git_repository
        # _______________________________________

            # Function downloading private git repository with given name.

            # Parameters description
            # **********************

                #   > $1 - module name
                #   > $2 - repository name
                #   > $3 - module path

            # Function definition
            # *******************

                download_private_git_repository()
                {
                    cd $FULL_PATH
                    remove_directory $3

                    $GIT_PRIVATE_REPOSITORY_DOWNLOAD_COMMAND"$2"

                    if [ "$?" = "0" ]; then
                        cd $3
                    else
                        # try again to download repository
                        remove_directory $3

                        $GIT_PRIVATE_REPOSITORY_DOWNLOAD_COMMAND"$2"

                        if [ "$?" = "0" ]; then
                            cd $3
                        else
                            error "$1 repository downloading failed. Possibly you have no permission to download it. For permission please contact with G4.19 team."
                        fi
                    fi
                }

        # Function switch_git_branch
        # __________________________

            # Function switching branch of current git repository.

            # Parameters description
            # **********************

                #   > $1 - branch name

            # Function definition
            # *******************

                switch_git_branch()
                {
                    $GIT_SWITCH_BRANCH$1

                    if [ "$?" != "0" ]; then
                        error "Switching branch on $1 failed."
                    fi
                }

    # Apache methods
    # --------------

        # Function apache_restart
        # _______________________

            # Function restarting apache server.

            # Parameters description
            # **********************

                # Function has no parameters.

            # Function definition
            # *******************

                apache_restart()
                {
                     service apache2 restart

                    if [ "$?" != "0" ]; then
                        error "Apache server restarting failed."
                    fi
                }

        # Function apache_reload
        # ______________________

            # Function reloading apache server.

            # Parameters description
            # **********************

                # Function has no parameters.

            # Function definition
            # *******************

                apache_reload()
                {
                     service apache2 reload

                    if [ "$?" != "0" ]; then
                        error "Apache server restarting failed."
                    fi
                }

    # Web packages methods
    # --------------------

        # Function download_unpack
        # ________________________

            # Function downloading package with application, unpacked and raname it and remove downloaded package.

            # Parameters description
            # **********************

                #   > $1 - module name
                #   > $2 - module directory path
                #   > $3 - package url
                #   > $4 - package name
                #   > $5 - package name with extension

            # Function definition
            # *******************

                download_unpack()
                {
                    cd $FULL_PATH

                    wget $3

                    if [ "$?" = "0" ]; then
                        # unpack archive package

                        tar -xvzf $5

                        if [ "$?" = "0" ]; then
                            # remove downloaded archive package

                            rm $5

                            if [ "$?" = "0" ]; then
                                # rename package directory

                                mv $4 $2

                                if [ "$?" = "0" ]; then
                                    cd $2

                                    if [ "$?" != "0" ]; then
                                        error "There are some problems with $1 directory: $2."
                                    fi
                                else
                                    info $1" renaming directory failed: $4 -> $2."

                                    cd $4

                                    if [ "$?" != "0" ]; then
                                        error "There are some problems with $1 directory: $4."
                                    fi
                                fi
                            else
                                info $1" removing archive package failed after extracting."
                            fi
                        else
                            error $1" extracting files failed.";
                        fi
                    else
                        error $1" package downloading failed.";
                    fi
                }

    # Script functionallity methods
    # -----------------------------

        # Function continue_installation
        # ______________________________

            # Function checks conditions of installation continuation and goes to next tool installation or exit script with some updates and upgreades made just before.

            # Parameters description
            # **********************

                #   > $1 - module name

            # Function definition
            # *******************

                continue_installation()
                {
                    # decrement variable with number of NLP tools to control progress of installation process

                    let TOOLS_TO_INSTALL-=1

                    if [[ "$TOOLS_TO_INSTALL" == "$ZERO" ]]; then
                        # automatic updating and upgrading installed programs and cleaning after installations

                        aptget_update
                        aptget_upgrade
                        aptget_autoremove
                        aptget_autoclean

                        success "--- Installation complited! ---"

                        info "\nSystem should be restart now to accept all changes after NLP tools installation."
                        read -p "Do you want to restart system know? (Y/n)?" INPUT

                        if [[ $INPUT = [Yy] || $INPUT = "" ]]; then
                             reboot -h now
                        else
                            confirmed "Script exit without restarting system. Please remember to restart your system later!"
                            exit 1
                        fi
                    fi
                }
