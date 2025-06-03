/// 支持的国家语言列表
const List<Map<String, String>> countryCodes = [
  {
    "name": "China",
    "code": "CN",
    "dial_code": "+86",
    "index": "C",
  },
  {
    "name": "Hongkong",
    "code": "HK",
    "dial_code": "+852",
    "index": "H",
  },
  {
    "name": "臺灣",
    "code": "TW",
    "dial_code": "+886",
    "index": "T",
  },
  {
    "name": "United States",
    "code": "US",
    "dial_code": "+1",
    "index": "U",
  },
  {
    "name": "United Kingdom",
    "code": "GB",
    "dial_code": "+44",
    "index": "G",
  },
//   {
//     "name": "Thailand",
//     "code": "TH",
//     "dial_code": "+66",
//     "index": "T",
//   },
//   {
//     "name": "Malaysia",
//     "code": "MY",
//     "dial_code": "+60",
//     "index": "M",
//   },
//   {
//     "name": "Philippines",
//     "code": "PH",
//     "dial_code": "+63",
//     "index": "P",
//   },
//   {
//     "name": "Indonesia",
//     "code": "ID",
//     "dial_code": "+62",
//     "index": "I",
//   },
//   {
//     "name": "Viet Nam",
//     "code": "VN",
//     "dial_code": "+84",
//     "index": "V",
//   },
//   {
//     "name": "Singapore",
//     "code": "SG",
//     "dial_code": "+65",
//     "index": "S",
//   },
//   {
//     "name": "Brasil",
//     "code": "BR",
//     "dial_code": "+55",
//     "index": "B",
//   },
//   {
//     "name": "India",
//     "code": "IN",
//     "dial_code": "+91",
//     "index": "I",
//   },
];

/// 支持的国家字典
const countryCodeLang = {
  "CN": "China", // 中国
  "US": ["United States of America", "USA"], // 美国
  "HK": "Hongkong", //中国香港市
  "TW": "Taiwan", //中国台湾省
  // "TH": "Thailand", // 泰国
  // "MY": "Malaysia", // 马来西亚
  // "PH": "Philippines", //菲律宾
  // "ID": "Indonesia", // 印尼
  // "VN": "Vietnam", // 越南
  // "SG": "Singapore", // 新加坡
  // "BR": "Brazil", // 巴西
  // "IN": "India", // 印度
  "GB": ["United Kingdom", "UK", "Great Britain"], // 英国
};
