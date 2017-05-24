#!/bin/bash
# coding=utf-8

source common.sh

# System required tools installation
# ==================================

    aptget_update
    aptget_upgrade

    # Programming languages tools
    # ---------------------------

        # Java
        # ____

             apt-get install -y openjdk-7-jre openjdk-7-jdk

            if [ "$?" = "0" ]; then
                success "Java was successfully installed."
            else
                error "Java installation ended with error."
            fi

        # Python
        # ______

             apt-get install -y python-dev python-pip python-setuptools python-software-properties

            if [ "$?" = "0" ]; then
                success "Python was successfully installed."
            else
                error "Python installation ended with error."
            fi

    # System required
    # ---------------

        # Compilers
        # _________

            # - cmake
            # - gcc
            # - g++

             apt-get install -y make cmake gcc g++

            if [ "$?" = "0" ]; then
                success "Compilers were successfully installed."
            else
                error "Compilers installation ended with error."
            fi

        # Revision control manager
        # ________________________

            # - git

             apt-get install -y git

            if [ "$?" = "0" ]; then
                success "Git was successfully installed."
            else
                error "Git installation ended with error."
            fi

        # Other programs
        # ______________

            # - vim
            # - ipython
            # - ant
            # - p7zip

             apt-get install -y vim ipython ant p7zip-full

            if [ "$?" = "0" ]; then
                success "Other programs were successfully installed."
            else
                error "Other programs installation ended with error."
            fi


