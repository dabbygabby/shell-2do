#!/bin/bash

source $HOME/Desktop/shell-2do/config.sh

activetodo=$TODOFOLDER/$ACTIVE_FILE
archivedFilepath=$HOME/Desktop/shell-2do/archive/

# Helper function to get numbee of lines in the todoList

len2do() {
    Tasks_remaining=$(wc -l <$activetodo)
    return $(($Tasks_remaining + 1))
}

mk2do() {
    if [ $# -eq 0 ]; then
        echo "no task was provided"
        echo "run help2do to see usage"
    else
        len2do
        echo "$? (_) $1" >>$activetodo
    fi
}

check2do() {
    if [ $# -eq 0 ]; then
        echo "no task id was provided"
        echo "run help2do to see usage"
    else
        query="$1 (_)"
        while read line; do
            chars=${line:0:5}
            if [[ $chars == $query ]]; then
                sed -i "s/$chars/$1 (x)/g" $activetodo
            fi
        done <$activetodo
    fi
}

uncheck2do() {
    if [ $# -eq 0 ]; then
        echo "no task id was provided"
        echo "run help2do to see usage"
    else
        query="$1 (x)"
        while read line; do
            chars=${line:0:5}
            if [[ $chars == $query ]]; then
                sed -i "s/$chars/$1 (_)/g" $activetodo
            fi
        done <$activetodo
    fi
}

lsall2do() {
    while read line; do
        echo $line
    done <$activetodo
}

lscomplete2do() {
    query="(x)"
    while read line; do
        chars=${line:2:3}
        if [[ $chars == $query ]]; then
            echo $line
        fi
    done <$activetodo
}

ls2do() {
    query="(_)"
    while read line; do
        chars=${line:2:3}
        if [[ $chars == $query ]]; then
            echo $line
        fi
    done <$activetodo
}

rm2do() {
    if [ $# -eq 0 ]; then
        echo "no task id was provided"
        echo "run help2do to see usage"
    else
        query="$1 (x)"
        query2="$1 (_)"
        while read line; do
            chars=${line:0:5}
            if [[ $chars == $query ]]; then
                sed -i "s/$line//g" $activetodo
            fi
            if [[ $chars == $query2 ]]; then
                sed -i "s/$line//g" $activetodo
            fi
        done <$activetodo
    fi
}

clear2do() {
    lsall2do
    echo "Are you sure you want to delete this todo list?(y/N)"
    read option
    echo $option
    if [[ $option == 'y' || $option == 'Y' ]]; then
        echo "deleted"
        mv $activetodo $archivedFilepath
        touch $activetodo
    else
        echo "List not deleted"
    fi
}

mk2dolist() {
    echo "what would you use this to do list for?"
    read listname
    touch $TODOFOLDER/$listname.md
    echo "$listname saved successfully!"
}

active2do() {
    echo $ACTIVE_FILE
}

list2do() {
    ls $TODOFOLDER
}

switch2do() {
    if [ $# -eq 0 ]; then
        echo "please provide a list name to switch to"
        echo "run help2do to see usage"
        echo "\n=================AVAILABLE LISTS ===================\n"
        list2do
    else
        export ACTIVE_FILE=$1.md
        echo $ACTIVE_FILE
        activetodo=$TODOFOLDER/$ACTIVE_FILE
    fi
}

help2do() {
    echo "2do list HELP"
    echo "AUTHOR: dabbygabby"
    echo "available commands-"
    echo "COMMAND         DESCRIPTION                   Usage example"
    echo "ls2do           'list all incomplete todos'   ls2do"
    echo "mk2do           'add new todo'                mk2do 'this is a new task(string)"
    echo "check2do        'mark as done with todoId'    check2do 1"
    echo "uncheck2do      'mark as undone with todoId'  uncheck2do 1"
    echo "lsall2do        'lists all todos'             lsall2do"
    echo "lscomplete2do   'lists all completed todos'   lscomplete2do'"
    echo "len2do          'length of the todo list'     len2do"
    echo "clear2do        'deletes the todo list'       clear2do"
    echo "rm2do           'deletes todo with todoID'    rm2do 1"
    echo "mk2dolist       'make a new todo list'        mk2dolist"
    echo "switch2do       'switch todo list'            switch2do todo"
    echo "active2do       'current to do list'          active2do"
    echo "list2do         'list all to do lists'        list2do"

}
