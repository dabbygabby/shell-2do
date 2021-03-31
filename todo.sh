#!/bin/bash

filepath="/home/dabbygabby/todoshellfiles/todo.md"
archivedFilepath="/home/dabbygabby/todoshellfiles/archive/"

# Helper function to get numbee of lines in the todoList

len2do() {
    Tasks_remaining=$(wc -l <$filepath)
    return $(($Tasks_remaining + 1))
}

2do() {
    if [ $# -eq 0 ]; then
        echo "no task was provided"
        echo "run help2do to see usage"
    else
        len2do
        echo "$? (_) $1" >>$filepath
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
                sed -i "s/$chars/$1 (x)/g" $filepath
            fi
        done <$filepath
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
                sed -i "s/$chars/$1 (_)/g" $filepath
            fi
        done <$filepath
    fi
}

lsall2do() {
    while read line; do
        echo $line
    done <$filepath
}

lscomplete2do() {
    query="(x)"
    while read line; do
        chars=${line:2:3}
        if [[ $chars == $query ]]; then
            echo $line
        fi
    done <$filepath
}

ls2do() {
    query="(_)"
    while read line; do
        chars=${line:2:3}
        if [[ $chars == $query ]]; then
            echo $line
        fi
    done <$filepath
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
                sed -i "s/$line//g" $filepath
            fi
            if [[ $chars == $query2 ]]; then
                sed -i "s/$line//g" $filepath
            fi
        done <$filepath
    fi
}

clear2do() {
    lsall2do
    echo "Are you sure you want to delete this todo list?(y/N)"
    read option
    echo $option
    if [[ $option == 'y' || $option == 'Y' ]]; then
        echo "deleted"
        mv $filepath $archivedFilepath
        touch $filepath
    else
        echo "List not deleted"
    fi
}

help2do() {
    echo "2do list HELP"
    echo "AUTHOR: dabbygabby"
    echo "available commands-"
    echo "COMMAND         DESCRIPTION                   Usage example"
    echo "ls2do           'list all incomplete todos'   ls2do"
    echo "2do             'add new todo'                mk2do 'this is a new task(string)"
    echo "check2do        'mark as done with todoId'    check2do 1"
    echo "uncheck2do      'mark as undone with todoId'  uncheck2do 1"
    echo "lsall2do        'lists all todos'             lsall2do"
    echo "lscomplete2do   'lists all completed todos'   lscomplete2do'"
    echo "len2do          'length of the todo list'     len2do"
    echo "clear2do        'deletes the todo list'       clear2do"
    echo "rm2do           'deletes todo with todoID'    rm2do 1"
}
