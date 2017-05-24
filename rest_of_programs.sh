#!/bin/bash
# coding=utf-8

source common.sh

        # Required programs installation
        # ______________________________

            # Corpus NKJP installation
            # ************************

                # Model NKJP (Narodowy Korpus Języka Polskiego, en. National Corpus of Polish Language)
                # http://nkjp.pl/

                create_directory $NKJP_CORPUS_MODEL_PATH

                # download NKJP corpus model, if not exists

                if ! [ -f $NKJP_CORPUS_PACKAGE_NAME ]; then
                    # download NKJP corpus

                    wget $NKJP_CORPUS_DOWNLOAD_LINK

                    if [ "$?" != "0" ]; then
                        error "NKJP corpus downloading archive package failed."
                    fi
                fi

                # extract archive package with corpus NKJP model to system path

                 7za -y x $NKJP_CORPUS_PACKAGE_NAME -o"$NKJP_CORPUS_MODEL_SYSTEM_DIRECTORY"

                if [ "$?" = "0" ]; then
                     ldconfig

                    if [ "$?" != "0" ]; then
                        error "System reloading command ended with errors."
                    fi
                else
                    error "NKJP corpus installation failed."
                fi

                info "NKJP model was successfully installed."

        # Installation summary
        # ____________________

            # show massage with success installation information

            success "Wcrft module was successfully installed!\n\n\tInstallation progress:\t5 / $TOOLS_SET_VERSION_NUMBER"

            continue_installation

    # Module Iobber
    # -------------

        # http://www.nlp.pwr.wroc.pl/redmine/projects/iobber/wiki

        # Repository downloading
        # ______________________

            # http://nlp.pwr.wroc.pl/iobber.git

            remove_directory $IOBBER_PATH

            download_public_git_repository "Iobber" "iobber" $IOBBER_PATH

            cd $IOBBER_PATH

        # Module installation
        # ___________________

            python_install "Iobber"

        # Installation testing
        # ____________________

            # import test of Iobber module

            test_import "Iobber" "iobber"

            # analysis test of Iobber module

                # !!! SKIP
                # analysis test causing errors, because Iobber module wants to wcrft2 in place of wcrft

                # test_analyse "Iobber" "iobber_txt - -o none"

        # Installation summary
        # ____________________

            # show massage with success installation information

            success "Iobber module was successfully installed!\n\n\tInstallation progress:\t6 / $TOOLS_SET_VERSION_NUMBER"

            # decrement variable with number of NLP tools to control progress of installation process

            continue_installation

    # Module QA
    # ---------

        # about Question Answering module:
        # http://www.nlp.pwr.wroc.pl/redmine/projects/qa/wiki

        # about Question Answering installation process:
        # http://www.nlp.pwr.wroc.pl/redmine/projects/qa/wiki/Instalacja_prototypu#Instalacja-wymaganych-modułów

        # Repository downloading
        # ______________________

            # http://nlp.pwr.wroc.pl/qa.git

            download_private_git_repository "Question Answering" "qa" $QA_PATH

        # Required packages installation
        # ______________________________

            # Python
            # ******

                # Packages installation
                # '''''''''''''''''''''

                    #   > numpy
                    #   > scipy
                    #   > MySQLdb
                    #   > ZSI
                    #   > networkx

                     apt-get install -y python-numpy python-scipy python-mysqldb python-zsi python-networkx

                    if [ "$?" != "0" ]; then
                        error "Python packages installation failed."
                    fi

                    #   > pyyaml
                    #   > nltk

                     pip install -U pyyaml nltk

                    if [ "$?" != "0" ]; then
                        error "Python packages installation failed."
                    fi

                    #   > gensim

                     pip install gensim

                    if [ "$?" != "0" ]; then
                         easy_install -U gensim

                        if [ "$?" != "0" ]; then
                            error error "Python module Gensim installation failed."
                        fi
                    fi

                    info "Python packages were successfully installed."

                # Build directory removing
                # ''''''''''''''''''''''''

                    remove_directory $PYTHON_BUILD_DIRECTORY

                # Packages import testing
                # '''''''''''''''''''''''

                    # test importing numpy, scipy, ZSI, networkx, pyyaml, nltk and gensim

                    test_import "Numpy python module" "numpy"
                    test_import "Scipy python module" "scipy"
                    test_import "MySQLdb python module" "MySQLdb"
                    test_import "ZSI python module" "ZSI"
                    test_import "NetworkX python module" "networkx"
                    test_import "Yaml python module" "yaml"
                    test_import "Nltk python module" "nltk"
                    test_import "Gensim python module" "gensim"

        # Required programs installation
        # ______________________________

            # PYPLWN
            # ******

                # python wrappers for PlWordNet
                # http://plwordnet.pwr.wroc.pl/wordnet/

                # Prepare installation
                # ''''''''''''''''''''

                    cd $PYPLWN_PATH

                    if [ "$?" != "0" ]; then
                        error "Pyplwn repository does not exists: $PYPLWN_PATH."
                    fi

                # Install module
                # ''''''''''''''

                    python_install "Pyplwn"

                    if [ "$?" != "0" ]; then
                        error "Pyplwn installation failed."
                    fi

                # Test module
                # '''''''''''

                    # test importing pyplwn

                    test_import "Pyplwn" "pyplwn"

            # MaltParser
            # **********

                # http://www.maltparser.org/

                remove_directory $MALTPARSER_PATH

                download_unpack "MaltParser" $MALTPARSER_PATH $MALTPARSER_DOWNLOAD_LINK $MALTPARSER_DIRECTORY_NAME $MALTPARSER_PACKAGE_NAME

                mv $MALTPARSER_PATH$MALTPARSER_APPLICATION_START_FILE $MALTPARSER_START_JAR

                if [ "$?" != "0" ]; then
                    error "Maltparser start application jar renaming failed."
                fi

        # Configurating module
        # ____________________

            # Creating local configuration file
            # *********************************

                # copy "questionanswering/app_configs/tool_config.ini" file and raname copy as "tool_config.local.ini" to create local configuration file
                
                cd $QA_CONFIGURATION_DIRECTORY

                if [ "$?" != "0" ]; then
                    error "QA module configuration directory does not exist."
                fi

                cp $QA_DEFAULT_CONFIGURATION_FILE $QA_LOCAL_CONFIGURATION_FILE

                if [ "$?" != "0" ]; then
                    error "QA module local configuration file creation failed."
                fi

            # Setting changes in local configuration
            # **************************************

                sed -i "s/;//g" $QA_LOCAL_CONFIGURATION_FILE

                if [ "$?" = "0" ]; then
                    # set path to maltparser JAR library

                    sed -i "s/malt.jar/"${$MALTPARSER_START_JAR//\//\\/}"/g" $QA_LOCAL_CONFIGURATION_FILE

                    # set path to maltparser data directory

                    sed -i "s/data_model_localization = /data_model_localization = "${$QA_MALTPARSER_DIRECTORY//\//\\/}"/g" $QA_LOCAL_CONFIGURATION_FILE

                    if [ "$?" != "0" ]; then
                        error "Setting path to Maltparser in QA module local configuration file failed."
                    fi
                else
                    error "Uncommenting maltparser section in QA module local configuration file failed."
                fi

        # Module installation
        # ___________________

            cd $QA_PATH
            
            python_install "Question Answering"

        # Installation testing
        # ____________________

            test_import "Question Answering" "questionanswering"

        # Installation summary
        # ____________________

            # show massage with success installation information

            success "QA module was successfully installed!\n\n\tInstallation progress:\t7 / $TOOLS_SET_VERSION_NUMBER"

            continue_installation

    # Additional tools installation
    # -----------------------------

        # Required programs installation
        # ______________________________

            # MySQL
            # *****

                # install MySQL libraries

                 apt-get install -y mysql-server mysql-client

                if [ "$?" != "0" ]; then
                    error "MySQL installation failed."
                fi

            # Apache
            # ******

                # Apache server installation
                # ''''''''''''''''''''''''''

                    # - WSGI
                    # - expat1
                    # - ssl-cert

                    # install Apache2.2 libraries

                     apt-get install -y apache2 apache2.2-common apache2-mpm-prefork apache2-utils

                # Modules installation
                # ''''''''''''''''''''

                    if [ "$?" = "0" ]; then
                        # install Apache2.2 modules

                         apt-get install -y libapache2-mod-wsgi libexpat1 ssl-cert

                        if [ "$?" != "0" ]; then
                            error "Apache modules installation failed."
                        fi
                    else
                        error "Apache installation failed."
                    fi

                # Apache server name registration
                # '''''''''''''''''''''''''''''''

                    if [ ! grep -q $APACHE_CONFIGURATION_STRING $APACHE_CONFIGURATION_FILE ]; then
                         sh -c $APACHE_CONFIGURATION_STRING
                    fi

                apache_restart

        # Required packages installation
        # ______________________________

            # PHP
            # ***

                # install PHP libraries

                 apt-get install -y php5 php5-mysql libapache2-mod-php5

                if [ "$?" = "0" ]; then
                    apache_restart
                else
                    error "PHP installation failed."
                fi

        # Solr
        # ____

            # http://lucene.apache.org/solr/

            # Downloading tool package
            # ************************

                remove_directory $SOLR_PATH

                download_unpack "Solr" $SOLR_PATH $SOLR_DOWNLOAD_LINK $SOLR_DIRECTORY_NAME $SOLR_PACKAGE_NAME

            # Adding Apache server configuration
            # **********************************

                # create configuration file

                (echo "Alias /solr "$DATA_PATH"solr"; echo ""; echo "<Directory "$SOLR_PATH">"; echo $SOLR_CONFIGURATION_OPTIONS; echo $SOLR_CONFIGURATION_ORDER; echo $SOLR_CONFIGURATION_ALLOW; echo "</Directory>") > $SOLR_APACHE_CONFIGURATION_FILE_NAME

                if [ "$?" = "0" ]; then
                    # move Solr configuration file to Apache configurations directory

                     mv $SOLR_APACHE_CONFIGURATION_FILE_NAME $SOLR_APACHE_CONFIGURATION_FILE

                    if [ "$?" != "0" ]; then
                        error "Solr configuration file for Apache could not be moved to Apache configuration directory: $SOLR_APACHE_CONFIGURATION_FILE."
                    fi
                else
                    error "Solr configuration file for Apache creation failed."
                fi

                # register Solr configuration in Apache

                 a2ensite $SOLR_APACHE_CONFIGURATION_FILE_NAME

                if [ "$?" = "0" ]; then
                    apache_reload
                    apache_restart
                else
                    error "Solr configuration file registration in Apache failed."
                fi

            # Making Solr startup application
            # *******************************

                cd $SOLR_PATH

                if [ ! -f $SOLR_STARTUP_SCRIPT ]; then
                    (echo "#!/bin/bash"; echo ""; echo "cd "$SOLR_PATH"example/"; echo "java -jar start.jar > /dev/null &") > $SOLR_STARTUP_SCRIPT_NAME

                    if [ "$?" != "0" ]; then
                        error "Solr startup script creation failed."
                    fi

                    # move Solr startup script to it's directory

                     mv $SOLR_STARTUP_SCRIPT_NAME $INIT_DIRECTORY

                    if [ "$?" == "0" ]; then
                         chmod 755 $SOLR_STARTUP_SCRIPT

                        if [ "$?" == "0" ]; then
                            # add Solr startup script to rc.local registry

                             update-rc.d $SOLR_STARTUP_SCRIPT_NAME defaults

                            if [ "$?" != "0" ]; then
                                error "Solr startup script adding to RC.LOCAL registry failed."
                            fi
                        else
                            error "Adding permissions for read and executing (755) on: "$SOLR_STARTUP_SCRIPT" failed."
                        fi
                        
                    else
                        error "Solr startup script moving failed."
                    fi
                fi

            # Change QA configuration
            # ***********************

                # Setting changes in QA configuration
                # '''''''''''''''''''''''''''''''''''

                    cd $QA_CONFIGURATION_DIRECTORY

                    # set host ip of server with Solr application

                    sed -i "s/156.17.134.45:8984/"$HOST":8983/g" $QA_LOCAL_CONFIGURATION_FILE

                    if [ "$?" != "0" ]; then
                        error "Setting host ip to server with Solr application in Question Answering module local configuration file failed."
                    fi

                # Reinstalling QA module
                # ''''''''''''''''''''''

                    cd $QA_PATH

                    python_install "Question Answering"

                # Installation summary
                # ''''''''''''''''''''

                    # show massage with success installation information

                    success "Solr was successfully installed!\n\n\tInstallation progress:\t8 / $TOOLS_SET_VERSION_NUMBER"

        # Ner-ws
        # ______

            # http://www.nlp.pwr.wroc.pl/redmine/projects/ner-ws/wiki

            # Downloading repository
            # **********************

                remove_directory $NERWS_PATH
                remove_directory $NERWS_SHARED_PATH

                download_private_git_repository "Ner-ws" "ner-ws" $NERWS_PATH

                cd $NERWS_PATH

            # Preparing MySQL database for Ner-ws
            # ***********************************

                # send communicate to type MySQL password

                info "MySql root password to create database '"$NERWS_DB_NAME"', user '"$NERWS_DB_USER"' and grant privileges."        

                mysql -u root -p -e "create database "$NERWS_DB_NAME";create user '"$NERWS_DB_USER"'@'localhost' identified by '"$NERWS_DB_PASS"';create user '$NERWS_DB_USER'@'%' identified by '"$NERWS_DB_PASS"';grant all privileges on * . * to '"$NERWS_DB_USER"'@'localhost';grant all privileges on * . * to '"$NERWS_DB_USER"'@'%';flush privileges;"

                success "Database "$NERWS_DB_NAME" and user "$NERWS_DB_USER" were successfully created".


                # send communicate to type MySQL password

                info "MySql root password to fill database '"$NERWS_DB_NAME"' with SQL dump file from Ner-ws repository"

                mysql -u root -p $NERWS_DB_NAME < $NERWS_DATABASE_DUMP_FILE_PATH

                success "Database "$NERWS_DB_NAME" was successfully loaded with SQL dump file: "$NERWS_DATABASE_DUMP_FILE_PATH"."

            # Configuration of Ner-ws database connections
            # ********************************************

                rm $NERWS_CONFIG_FILE_PATH

                if [ "$?" = "0" ]; then
                    # create new config file

                    (echo "<?"; echo "ini_set('display_errors', 1);"; echo ""; echo "// database access data"; echo '$cfg_db_host = "'$HOST'";'; echo '$cfg_db_user = "'$NERWS_DB_USER'";'; echo '$cfg_db_pass = "'$NERWS_DB_PASS'";'; echo '$cfg_db_name = "'$NERWS_DB_NAME'";'; echo ""; echo '$cfg_liner2_ws = "'$NERWS_WSDL_FILE_NAME'";'; echo '$cfg_dir = "'$NERWS_SHARED_WS_PATH'";'; echo ""; echo "// daemon management data"; echo "$cfg_daemon_ping_interval = 2;"; echo "$cfg_daemon_ping_timeout = 10;"; echo "$cfg_daemon_ping_max_unanswered = 10;"; echo ""; echo "?>") > $NERWS_CONFIG_FILE_PATH

                    if [ "$?" != "0" ]; then
                        error "Ner-ws config file creation failed."
                    fi
                else
                    error "Ner-ws file removing failed: "$NERWS_CONFIG_FILE_PATH"."
                fi

                # change host ip number in WSDL file

                sed -i "s/188.124.184.105/"$HOST"/g" $NERWS_WSDL_FILE_PATH

                if [ "$?" = "0" ]; then
                    # remove old and create new log file

                    rm $NERWS_LOG_CONFIG_FILE_PATH

                    if [ "$?" = "0" ]; then
                        (echo "<?"; echo '$path = "'$NERWS_LOG_PATH'";'; echo '$logfile = fopen($path, "a+") or die($path);'; echo ""; echo "function write_log($msg) {"; echo "  global $logfile;"; echo "  fwrite($logfile, $msg);"; echo "}"; echo ""; echo 'write_log(sprintf("=== %s ===\n", date("d.m.Y H:i:s")));"'; echo "?>"; echo "") > $NERWS_LOG_CONFIG_FILE_PATH

                        if [ "$?" != "0" ]; then
                            error "Ner-ws log file creation failed."
                        fi
                    else
                        error "Ner-ws file removing directory failed: "$NERWS_LOG_CONFIG_FILE_PATH"."
                    fi
                else
                    error "Ner-ws changing host ip address in WSDL file failed."
                fi

                create_directory $NERWS_LOG_DIRECTORY
                touch $NERWS_LOG_FILE_PATH

                if [ "$?" != "0" ]; then
                    error "Creating log text file failed: "$NERWS_LOG_FILE_PATH"."
                fi

                mv $NERWS_PUBLIC_HTML_PATH $DATA_PATH

                if [ "$?" != "0" ]; then
                    error "Moving file failed: "$NERWS_PUBLIC_HTML_PATH"."
                fi

                mv $DATA_PATH"public_html/" $NERWS_SHARED_PATH

                if [ "$?" != "0" ]; then
                    error "Moving directory failed: "$DATA_PATH"public_html/."
                fi

            # Adding Apache server configuration
            # **********************************

                (echo "Alias /nerws "$NERWS_SHARED_PATH; echo ""; echo "<Directory "$NERWS_SHARED_PATH">"; echo $SOLR_CONFIGURATION_OPTIONS; echo $SOLR_CONFIGURATION_ORDER; echo $SOLR_CONFIGURATION_ALLOW; echo "</Directory>") > $NERWS_APACHE_CONFIGURATION_FILE_NAME

                if [ "$?" = "0" ]; then
                    # move Ner-ws configuration file to Apache configurations directory

                     mv $NERWS_APACHE_CONFIGURATION_FILE_NAME $NERWS_APACHE_CONFIGURATION_FILE

                    if [ "$?" != "0" ]; then
                        error "Ner-ws configuration file for Apache could not be moved to Apache configuration directory: "$NERWS_APACHE_CONFIGURATION_FILE"."
                    fi
                else
                    error "Ner-ws configuration file for Apache creation failed."
                fi

                # register Ner-ws configuration in Apache

                 a2ensite $NERWS_APACHE_CONFIGURATION_FILE_NAME

                if [ "$?" = "0" ]; then
                    apache_reload
                    apache_restart
                else
                    error "Ner-ws configuration file registration in Apache failed."
                fi

                 chmod 755 ""$DATA_PATH"nerws"

                if [ "$?" = "0" ]; then
                     chmod -R 755 ""$DATA_PATH"nerws/"

                    if [ "$?" != "0" ]; then
                        error "Ner-ws adding permissions to shared folder failed."
                    fi
                else
                    error "Ner-ws adding permissions to shared folder failed."
                fi

        # Liner2
        # ______

            # http://www.nlp.pwr.wroc.pl/redmine/projects/inforex-liner/wiki

            # Downloading repository
            # **********************

                remove_directory $LINER_PATH

                download_private_git_repository "Liner 2.4" "liner2" $LINER_PATH

                switch_git_branch "dev"

            # Installing required tools
            # *************************

                # CRF++ 0.57
                # ''''''''''

                    cd $LINER_LIBRARY_PATH

                    if [ "$?" = "0" ]; then
                        # extract package

                        tar -zxvf $LINER_CRFPP_PACKAGE_NAME

                        if [ "$?" != "0" ]; then
                            error "Liner2 package extracting failed."
                        fi
                    else
                        error "Liner2 has no directory with CRF++ 0.57 package: "$LINER_LIBRARY_PATH"."
                    fi

                    cd $LINER_CRFPP_JAVA_PATH

                    if [ "$?" = "0" ]; then
                        make

                        if [ "$?" != "0" ]; then
                            error "Liner2 make compilation failed."
                        fi
                    else
                        error "Liner2 has no directory with java for CRF++ 0.57: "$LINER_CRFPP_JAVA_PATH"."
                    fi

                    # copying compiled libraries

                    cp $LINER_LIBRARY_SO $LINER_LIBRARY_PATH

                    if [ "$?" = "0" ]; then
                        cp $LINER_LIBRARY_JAR $LINER_LIBRARY_PATH

                        if [ "$?" != "0" ]; then
                            error "Liner2 library copying failed."
                        fi
                    else
                        error "Liner2 library copying failed."
                    fi
                    
                    cd $LINER_PATH

                    ant jar

                    if [ "$?" != "0" ]; then
                        error "Liner2 generating starting JAR library failed."
                    fi

            # Downloading model
            # *****************

                download_unpack "Liner model" $LINER_MODEL_PATH $LINER_MODEL_DOWNLOAD_LINK $LINER_MODEL_DIRECTORY_NAME $LINER_MODEL_PACKAGE_NAME

            # Making Liner startup application
            # ********************************

                cd $LINER_PATH

                if [ ! -f $LINER_STARTUP_SCRIPT ]; then
                    (echo "#!/bin/bash"; echo ""; echo "cd "$LINER_PATH; echo "./liner2-daemon -models model/models.ini -db_uri "$NERWS_DB_USER":"$NERWS_DB_PASS"@"$HOST":3306/nerws -ip "$HOST" -p 3333 -verbose > /dev/null &") > $LINER_STARTUP_SCRIPT_NAME

                    if [ "$?" != "0" ]; then
                        error "Liner startup script creation failed."
                    fi

                    # move Liner startup script to it's directory

                     mv $LINER_STARTUP_SCRIPT_NAME $INIT_DIRECTORY

                    if [ "$?" == "0" ]; then
                         chmod 755 $LINER_STARTUP_SCRIPT

                        if [ "$?" == "0" ]; then
                            # add Liner startup script to rc.local registry

                             update-rc.d $LINER_STARTUP_SCRIPT_NAME defaults

                            if [ "$?" != "0" ]; then
                                error "Liner startup script adding to RC.LOCAL registry failed."
                            fi
                        else
                            error "Adding permissions for read and executing (755) on: "$LINER_STARTUP_SCRIPT" failed."
                        fi
                    else
                        error "Liner startup script moving failed."
                    fi
                fi

            # Change QA configuration
            # ***********************

                # Setting changes in QA configuration
                # '''''''''''''''''''''''''''''''''''

                    cd $QA_CONFIGURATION_DIRECTORY

                    # set host ip of server with Solr application
                    sed -i "s/156.17.129.133/"$HOST"/g" $QA_LOCAL_CONFIGURATION_FILE

                    if [ "$?" != "0" ]; then
                        error "Setting host ip to server with Liner application in Question Answering module local configuration file failed."
                    fi

                # Reinstalling QA module
                # ''''''''''''''''''''''

                    cd $QA_PATH

                    python_install "Question Answering"

            # Installation summary
            # ********************

                # show massage with success installation information

                success "Liner was successfully installed!\n\n\tInstallation progress:\t8 / $TOOLS_SET_VERSION_NUMBER"

                continue_installation
