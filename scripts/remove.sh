#!/bin/bash
cd /backups && (ls -t|head -n 10;ls)|sort|uniq -u|xargs rm
cd /
