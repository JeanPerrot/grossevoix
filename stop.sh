#!/bin/bash
ps -ef | grep coffee | awk '{print $2}' | xargs sudo kill
