#!/bin/bash
# coding=utf-8

source common.sh


# NLP tools installation
# ======================

    # depending on user input number of NLP tools set, script will install right NLP tools and required programs.

    # Module Corpus2
    # --------------

        # http://www.nlp.pwr.wroc.pl/redmine/projects/corpus2/wiki

        # Required tools installation
        # ___________________________

            # - Boost 1.41 or later (tested with 1.41, 1.42 and 1.47)
            # - ICU (tested with 4.2)
            # - LibXML++
            # - Bison
            # - Flex
            # - Loki
            # - Swig (tested with 1.3 and 2.0)

             apt-get install -y libboost-all-dev libicu-dev libxml++2.6-dev bison flex libloki-dev libedit-dev libantlr-dev swig

            if [ "$?" != "0" ]; then
                error "Corpus2 required programs installation ended with error."
            fi

        # Repository downloading
        # ______________________

            # http://nlp.pwr.wroc.pl/corpus2.git

            download_public_git_repository "Corpus2" "corpus2" $CORPUS2_PATH

        # Module installation
        # ___________________

            create_directory $CORPUS2_PATH"bin/"

            # compile Corpus2 with cmake and make

            cmake -D "CORPUS2_BUILD_POLIQARP:BOOL=True" ..

            if [ "$?" = "0" ]; then
                make -j

                if [ "$?" != "0" ]; then
                    info "Repeat making command to omit errors."

                    # try making command twice to omit errors

                    make -j

                    if [ "$?" != "0" ]; then
                        error "$1 make compilation failed."
                    fi
                fi
            else
                error "Corpus2 cmake compilation failed."
            fi

            make_install "Corpus2"

        # Installation tests
        # __________________

            # test importing corpus2

            test_import "Corpus2" "corpus2"

        # Installation summary
        # ____________________

            # show massage with success installation information

            success "Corpus2 module was successfully installed!\n\n\tInstallation progress:\t1 / $TOOLS_SET_VERSION_NUMBER"

    # Module Toki
    # -----------

        # http://www.nlp.pwr.wroc.pl/redmine/projects/toki/wiki

        # Repository downloading
        # ______________________

            # http://nlp.pwr.wroc.pl/toki.git

            download_public_git_repository "Toki" "toki" $TOKI_PATH

        # Module installation
        # ___________________

            create_directory $TOKI_PATH"bin/"
            # compile Toki with cmake and make

            cmake ..

            if [ "$?" = "0" ]; then
                make -j

                if [ "$?" != "0" ]; then
                    info "Repeat making command to omit errors."

                    # try making command twice to omit errors

                    make -j

                    if [ "$?" != "0" ]; then
                        error "Toki make compilation failed."
                    fi
                fi
            else
                error "Toki cmake compilation failed."
            fi

            make_install "Toki"

        # Installation summary
        # ____________________

            # show massage with success installation information

            success "Toki module was successfully installed!\n\n\tInstallation progress:\t2 / $TOOLS_SET_VERSION_NUMBER"

    # Module Maca
    # -----------

        # http://www.nlp.pwr.wroc.pl/redmine/projects/libpltagger/wiki

        # Repository downloading
        # ______________________

            # http://nlp.pwr.wroc.pl/maca.git

            download_public_git_repository "Maca" "maca" $MACA_PATH

        # Required programs installation
        # ______________________________

            # SFST
            # ****

                # tested with versions 1.2 or 1.3

                 apt-get install -y libsfst1-1.2-0 libsfst1-1.2-0-dev

                if [ "$?" = "0" ]; then
                    info "SFST for Maca module was successfully installed."
                else
                    # go to SFST directory in maca repository

                    SFST_PATH=$MACA_PATH"maca/third_party/SFST-1.2/SFST/src/"

                    if [ -d "$SFST_PATH" ]; then
                        if [ ! -L "$SFST_PATH" ]; then
                            # if directory exists, enter it and compile SFST with make

                            cd $SFST_PATH

                            make -j

                            if [ "$?" = "0" ]; then
                                make_install "SFST for Maca"
                            else
                                error "SFST for Maca module compilation ended with error."
                            fi
                        fi
                    else
                        error "SFST source directory couldn't be find in Maca repository."
                    fi
                fi

            # Morfeusz SGJP
            # *************

                if [ ! -f "$MORFEUSZ_SGJP_REPOSITORY_SOURCE_FILE" ]; then
                    # if repository of Morfeusz SGJP is not registred in apt, then register it

                     add-apt-repository -y ppa:bartosz-zaborowski/nlp

                    if [ "$?" != "0" ]; then
                        error "Morfeusz SGJP repository registration in apt unexpectively ended with errors."
                    fi
                fi

                # update system programs

                aptget_update

                # install Morfeusz SGJP

                 apt-get install morfeusz-sgjp

                if [ "$?" != "0" ]; then
                    error "Morfeusz SGJP installation ended with error."
                else
                    info "Morfeusz SGJP was successfully installed."
                fi

        # Module installation
        # ___________________

            create_directory $MACA_PATH"bin/"

            # compile Maca with cmake and make

            cmake ..

            if [ "$?" = "0" ]; then
                make -j

                if [ "$?" != "0" ]; then
                    info "Repeat making command to omit errors."

                    # try making command twice to omit errors

                    make -j

                    if [ "$?" != "0" ]; then
                        error "Maca make compilation failed."
                    fi
                fi
            else
                error "Maca cmake compilation failed."
            fi

            make_install "Maca"

        # Installation testing
        # ____________________

            # test importing maca

            test_import "Maca" "maca"

            # analysis test of Maca module

            test_analyse "Maca" "maca-analyse morfeusz-nkjp-official -q -o none"

        # Installation summary
        # ____________________

            # show massage with success installation information

            success "Maca module was successfully installed!\n\n\tInstallation progress:\t3 / $TOOLS_SET_VERSION_NUMBER"
