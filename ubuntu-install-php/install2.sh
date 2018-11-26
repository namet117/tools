#!/bin/bash

echo -e "\033[33m select php version: \033[0m"
echo '1：Install php version 5.6.38';
echo '2：Install php version 7.0.32';
echo '3：Install php version 7.1.24';
echo '4：Install php version 7.2.12';
echo '';
read -p 'Enter your choice (1, 2, 3, 4)：' INPUT_PHPVERSION;

case "${INPUT_PHPVERSION}" in
    1)
        PHPVERSION=5.6.38
        ;;
    2)
        PHPVERSION=7.0.32
        ;;
    3)
        PHPVERSION=7.1.24
        ;;
    4)
        PHPVERSION=7.2.12
        ;;
    *)
        echo -e "\033[31m Wrong Selected! \033[0m";
        exit 1;
        ;;
esac

echo ${PHPVERSION};
