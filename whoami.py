#!/usr/bin/env python3
""" Test aws toolkit in intellij
"""
import boto3

def get_sts_identity():
    """
    Returns the identity details of the AWS account and IAM user or role
    making the request.

    Returns:
    - dict: A dictionary containing Account, Arn, and UserId.
    """
    sts_client = boto3.client('sts')
    identity = sts_client.get_caller_identity()
    return identity