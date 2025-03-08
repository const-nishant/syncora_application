import 'package:flutter/material.dart';

import 'nftservices.dart';

class NFTScreen extends StatefulWidget {
  @override
  _NFTScreenState createState() => _NFTScreenState();
}

class _NFTScreenState extends State<NFTScreen> {
  final NFTService nftService = NFTService();
  List<NFT> nfts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNFTs();
  }

  void fetchNFTs() async {
    try {
      List<NFT> fetchedNFTs = await nftService.fetchNFTs();
      setState(() {
        nfts = fetchedNFTs;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching NFTs: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NFT Viewer")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : nfts.isEmpty
              ? const Center(child: Text("No NFTs found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: nfts.length,
                  itemBuilder: (context, index) {
                    NFT nft = nfts[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: nft.image.isNotEmpty
                            ? Image.network(nft.image,
                                width: 60, height: 60, fit: BoxFit.cover)
                            : const Icon(Icons.image, size: 60),
                        title: Text(nft.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(nft.description,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                    );
                  },
                ),
    );
  }
}
