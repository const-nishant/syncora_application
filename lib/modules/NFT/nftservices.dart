import 'dart:convert';

import 'package:http/http.dart' as http;

class NFTService {
  final String baseUrl =
      "https://81255eae-6d52-4622-a7cb-2dea4bdf798c-00-34u4anflkzbsi.riker.replit.dev"; // Flask API URL

  Future<List<NFT>> fetchNFTs() async {
    final response = await http.get(Uri.parse('$baseUrl/nfts'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<NFT> nfts =
          (data['nfts'] as List).map((json) => NFT.fromJson(json)).toList();
      return nfts;
    } else {
      throw Exception('Failed to load NFTs');
    }
  }
}

class NFT {
  final String name;
  final String description;
  final String image;

  NFT({required this.name, required this.description, required this.image});

  factory NFT.fromJson(Map<String, dynamic> json) {
    return NFT(
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'No description available',
      image: json['image'] ?? '',
    );
  }
}
