#!/usr/bin/python

import os
import boto

s3 = boto.connect_s3()

carmel_build_number = os.environ['AT_BUILD_NUMBER']
carmel_job_name = os.environ['AT_JOB_NAME']
carmel_git_branch = os.environ['AT_GIT_BRANCH']
bucket_key = 'jobs/' + carmel_job_name + '/' + carmel_build_number + '/' + 'libcarmel.tar.xz'

if carmel_git_branch == "adhoc":
    bucket = s3.get_bucket('airtime-eng-adhoc-libs')
else:
    bucket = s3.get_bucket('airtime-eng-libs')
md5 = bucket.get_key(bucket_key).etag[1 :-1]
print md5
