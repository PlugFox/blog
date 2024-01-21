//
//  Generated code. Do not modify.
//  source: api.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use responseDescriptor instead')
const Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 9, '10': 'status'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '10': 'error'},
    {'1': 'string', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'string'},
    {'1': 'bytes', '3': 4, '4': 1, '5': 12, '9': 0, '10': 'bytes'},
    {'1': 'article', '3': 5, '4': 1, '5': 11, '6': '.blog.api.Article', '9': 0, '10': 'article'},
    {'1': 'articles', '3': 6, '4': 1, '5': 11, '6': '.blog.api.Articles', '9': 0, '10': 'articles'},
    {'1': 'meta', '3': 1000, '4': 3, '5': 11, '6': '.blog.api.Response.MetaEntry', '10': 'meta'},
  ],
  '3': [Response_MetaEntry$json],
  '8': [
    {'1': 'data'},
  ],
  '9': [
    {'1': 7, '2': 1000},
  ],
};

@$core.Deprecated('Use responseDescriptor instead')
const Response_MetaEntry$json = {
  '1': 'MetaEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Response`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseDescriptor =
    $convert.base64Decode('CghSZXNwb25zZRIWCgZzdGF0dXMYASABKAlSBnN0YXR1cxIUCgVlcnJvchgCIAEoCVIFZXJyb3'
        'ISGAoGc3RyaW5nGAMgASgJSABSBnN0cmluZxIWCgVieXRlcxgEIAEoDEgAUgVieXRlcxItCgdh'
        'cnRpY2xlGAUgASgLMhEuYmxvZy5hcGkuQXJ0aWNsZUgAUgdhcnRpY2xlEjAKCGFydGljbGVzGA'
        'YgASgLMhIuYmxvZy5hcGkuQXJ0aWNsZXNIAFIIYXJ0aWNsZXMSMQoEbWV0YRjoByADKAsyHC5i'
        'bG9nLmFwaS5SZXNwb25zZS5NZXRhRW50cnlSBG1ldGEaNwoJTWV0YUVudHJ5EhAKA2tleRgBIA'
        'EoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAFCBgoEZGF0YUoFCAcQ6Ac=');

@$core.Deprecated('Use errorDescriptor instead')
const Error$json = {
  '1': 'Error',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 13, '10': 'status'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
    {'1': 'details', '3': 4, '4': 3, '5': 11, '6': '.blog.api.Error.DetailsEntry', '10': 'details'},
  ],
  '3': [Error_DetailsEntry$json],
};

@$core.Deprecated('Use errorDescriptor instead')
const Error_DetailsEntry$json = {
  '1': 'DetailsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Error`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptor =
    $convert.base64Decode('CgVFcnJvchIWCgZzdGF0dXMYASABKA1SBnN0YXR1cxISCgRjb2RlGAIgASgJUgRjb2RlEhgKB2'
        '1lc3NhZ2UYAyABKAlSB21lc3NhZ2USNgoHZGV0YWlscxgEIAMoCzIcLmJsb2cuYXBpLkVycm9y'
        'LkRldGFpbHNFbnRyeVIHZGV0YWlscxo6CgxEZXRhaWxzRW50cnkSEAoDa2V5GAEgASgJUgNrZX'
        'kSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use articleDescriptor instead')
const Article$json = {
  '1': 'Article',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'link', '3': 3, '4': 1, '5': 9, '10': 'link'},
    {'1': 'author', '3': 4, '4': 1, '5': 9, '10': 'author'},
    {'1': 'tags', '3': 5, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'createdAt', '3': 6, '4': 1, '5': 13, '10': 'createdAt'},
    {'1': 'updatedAt', '3': 7, '4': 1, '5': 13, '10': 'updatedAt'},
    {'1': 'excerpt', '3': 8, '4': 1, '5': 9, '10': 'excerpt'},
    {'1': 'content', '3': 9, '4': 1, '5': 9, '10': 'content'},
    {'1': 'meta', '3': 1000, '4': 3, '5': 11, '6': '.blog.api.Article.MetaEntry', '10': 'meta'},
  ],
  '3': [Article_MetaEntry$json],
  '9': [
    {'1': 10, '2': 1000},
  ],
};

@$core.Deprecated('Use articleDescriptor instead')
const Article_MetaEntry$json = {
  '1': 'MetaEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Article`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List articleDescriptor =
    $convert.base64Decode('CgdBcnRpY2xlEg4KAmlkGAEgASgJUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSEgoEbGluax'
        'gDIAEoCVIEbGluaxIWCgZhdXRob3IYBCABKAlSBmF1dGhvchISCgR0YWdzGAUgAygJUgR0YWdz'
        'EhwKCWNyZWF0ZWRBdBgGIAEoDVIJY3JlYXRlZEF0EhwKCXVwZGF0ZWRBdBgHIAEoDVIJdXBkYX'
        'RlZEF0EhgKB2V4Y2VycHQYCCABKAlSB2V4Y2VycHQSGAoHY29udGVudBgJIAEoCVIHY29udGVu'
        'dBIwCgRtZXRhGOgHIAMoCzIbLmJsb2cuYXBpLkFydGljbGUuTWV0YUVudHJ5UgRtZXRhGjcKCU'
        '1ldGFFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgBSgUI'
        'ChDoBw==');

@$core.Deprecated('Use articlesDescriptor instead')
const Articles$json = {
  '1': 'Articles',
  '2': [
    {'1': 'articles', '3': 1, '4': 3, '5': 11, '6': '.blog.api.Article', '10': 'articles'},
    {'1': 'count', '3': 2, '4': 1, '5': 13, '10': 'count'},
  ],
};

/// Descriptor for `Articles`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List articlesDescriptor =
    $convert.base64Decode('CghBcnRpY2xlcxItCghhcnRpY2xlcxgBIAMoCzIRLmJsb2cuYXBpLkFydGljbGVSCGFydGljbG'
        'VzEhQKBWNvdW50GAIgASgNUgVjb3VudA==');

@$core.Deprecated('Use logMessageDescriptor instead')
const LogMessage$json = {
  '1': 'LogMessage',
  '2': [
    {'1': 'timestamp', '3': 1, '4': 1, '5': 13, '10': 'timestamp'},
    {'1': 'level', '3': 2, '4': 1, '5': 13, '10': 'level'},
    {'1': 'prefix', '3': 3, '4': 1, '5': 9, '10': 'prefix'},
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
    {'1': 'stacktrace', '3': 5, '4': 1, '5': 9, '10': 'stacktrace'},
    {'1': 'context', '3': 6, '4': 3, '5': 11, '6': '.blog.api.LogMessage.ContextEntry', '10': 'context'},
    {'1': 'error', '3': 7, '4': 1, '5': 8, '10': 'error'},
  ],
  '3': [LogMessage_ContextEntry$json],
};

@$core.Deprecated('Use logMessageDescriptor instead')
const LogMessage_ContextEntry$json = {
  '1': 'ContextEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `LogMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logMessageDescriptor =
    $convert.base64Decode('CgpMb2dNZXNzYWdlEhwKCXRpbWVzdGFtcBgBIAEoDVIJdGltZXN0YW1wEhQKBWxldmVsGAIgAS'
        'gNUgVsZXZlbBIWCgZwcmVmaXgYAyABKAlSBnByZWZpeBIYCgdtZXNzYWdlGAQgASgJUgdtZXNz'
        'YWdlEh4KCnN0YWNrdHJhY2UYBSABKAlSCnN0YWNrdHJhY2USOwoHY29udGV4dBgGIAMoCzIhLm'
        'Jsb2cuYXBpLkxvZ01lc3NhZ2UuQ29udGV4dEVudHJ5Ugdjb250ZXh0EhQKBWVycm9yGAcgASgI'
        'UgVlcnJvcho6CgxDb250ZXh0RW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKA'
        'lSBXZhbHVlOgI4AQ==');
