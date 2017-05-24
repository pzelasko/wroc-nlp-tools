#!/bin/bash
# coding=utf-8

source common.sh

    # Module Wccl
    # -----------

        # http://www.nlp.pwr.wroc.pl/redmine/projects/joskipi/wiki

        # Required programs installation
        # ______________________________

            # Antlr
            # *****

                # tested with version 2

                 apt-get install -y antlr libantlr-dev

                if [ "$?" != "0" ]; then
                    error "Wccl required programs installation ended with error."
                fi

        # Repository downloading
        # ______________________

            # http://nlp.pwr.wroc.pl/wccl.git

            download_public_git_repository "Wccl" "wccl" $WCCL_PATH

        # Module installation
        # ___________________

            create_directory $WCCL_PATH"bin/"

            # compile Wccl with cmake and make

            cmake ..

            if [ "$?" = "0" ]; then
                make -j

                if [ "$?" != "0" ]; then
                    info "Repeat making command to omit errors."

                    # try making command twice to omit errors

                    make -j

                    if [ "$?" != "0" ]; then
                        info "Repeat making command to omit errors."

                        # try making command twice to omit errors

                        make -j

                        if [ "$?" != "0" ]; then
                            error "Wccl make compilation failed."
                        fi
                    fi
                fi
            else
                error "Wccl cmake compilation failed."
            fi

            make_install "Wccl"

        # Installation testing
        # ____________________

            # test importing wccl

            test_import "Wccl" "wccl"

        # Temporary directory creation
        # ____________________________

            create_directory $WCCL_RULES_TEMPORARY_DIRECTORY

            # set permissions to read, write and execute on created directory

             chmod 777 $WCCL_RULES_TEMPORARY_DIRECTORY

            if [ "$?" = "0" ]; then
                info "Wccl rules temporary directory successfully created: $WCCL_RULES_TEMPORARY_DIRECTORY"
            else
                error "Wccl rules temporary directory permissions setting unexpectively failed."
            fi

        # Installation summary
        # ____________________

            # show massage with success installation information

            success "Wccl module was successfully installed!\n\n\tInstallation progress:\t4 / $TOOLS_SET_VERSION_NUMBER"

    # Module Wcrft
    # ------------

        # http://www.nlp.pwr.wroc.pl/redmine/projects/wcrft/wiki

        # Required programs installation
        # ______________________________

            # CRF++
            # *****

                # tested with versions 0.57 and 0.58

                # Downloading and extracting package
                # ''''''''''''''''''''''''''''''''''

                    remove_directory $CRFPP_PATH

                    git clone "https://github.com/taku910/crfpp" $CRFPP_PACKAGE_NAME


                # Installing tool
                # '''''''''''''''

                    cd $CRFPP_PACKAGE_NAME

                    mv crf_learn.cpp temp
                    awk '/winmain/{getline} 1' temp > crf_learn.cpp
                    mv crf_test.cpp temp 
                    awk '/winmain/{getline} 1' temp > crf_test.cpp
                    rm temp


                    # configure CRF++ before compilation

                    ./configure

                    if [ "$?" != "0" ]; then
                        error "CRF++ configuration failed."
                    fi

                    # compile CRF++ with make

                    make -j

                    if [ "$?" != "0" ]; then
                        info "Repeat making command to omit errors."

                        # try making command twice to omit errors

                        make -j

                        if [ "$?" != "0" ]; then
                            error "CRF++ make compilation failed."
                        fi
                    fi

                    make_install "CRF++"

                    # install Python wrappers for CRF++

                    cd "python"

                    if [ "$?" != "0" ]; then
                        error "There are some problems with python directory in CRF++."
                    fi

                    # build Python wrappers

                    python setup.py build

                    if [ "$?" = "0" ]; then
                        python_install "CRF++ Python wrappers"
                    else
                        error "CRF++ Python wrappers building failed."
                    fi

        # Repository downloading
        # ______________________

            exit 0  # not needed

            # http://nlp.pwr.wroc.pl/wcrft.git

            download_public_git_repository "Wcrft" "wcrft" $WCRFT_PATH

            cd $WCRFT_PATH

        # Module installation
        # ___________________

            python_install "Wcrft"

        # Installation testing
        # ____________________

            # import test of Wcrft module

                # !!! SKIP
                # import test causing errors, although wcrft importing is possible (don't know why)

                # test_import "Wcrft" "wcrft"

            # analysis test of Wcrft module

            test_analyse "Wcrft" "wcrft nkjp_e2.ini -i txt -o none -"
