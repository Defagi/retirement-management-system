// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, use_key_in_widget_constructors, deprecated_member_use, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InvestmentFirm {
  final String name;
  final String website;
//  final IconData icon;

  InvestmentFirm(this.name, this.website,
  //  this.icon
  );
}
class InvestmentFirmListPage extends StatefulWidget {
  @override
  _InvestmentFirmListPageState createState() => _InvestmentFirmListPageState();
}
class _InvestmentFirmListPageState extends State<InvestmentFirmListPage> {
  List<InvestmentFirm> firms = [
  InvestmentFirm('Amana Bank', 'https://www.amanabank.co.tz/'),
  InvestmentFirm('Azania Bancorp', 'https://www.azaniabank.co.tz/'),
  InvestmentFirm('Bank M', 'https://www.bankm.co.tz/'),
  InvestmentFirm('Bank of Africa Tanzania', 'https://www.boafrica.com/'),
  InvestmentFirm('Bank of Baroda Tanzania', 'https://www.bankofbaroda.com/tz/'),
  InvestmentFirm('Barclays Bank Tanzania', 'https://www.absa.co.tz/'),
  InvestmentFirm('CRDB Bank', 'https://www.crdbbank.co.tz/'),
  InvestmentFirm('Custody & Allied Plc', 'https://www.custodyallied.com/'),
  InvestmentFirm('Diamond Trust Bank Tanzania', 'https://www.dtbafrica.com/'),
  InvestmentFirm('DSE Stockbrokers', 'https://www.dse.co.tz/'),
  InvestmentFirm('Ecobank Tanzania', 'https://www.ecobank.com/'),
  InvestmentFirm('Equity Bank Tanzania', 'https://www.ke.equitybankgroup.com/tz/'),
  InvestmentFirm('Exim Bank Tanzania', 'https://www.eximbank-tz.com/'),
  InvestmentFirm('First National Bank Tanzania', 'https://www.fnbtanzania.co.tz/'),
  InvestmentFirm('I&M Bank Tanzania', 'https://www.imbank.com/tz/'),
  InvestmentFirm('Jisort Financial Solutions', 'https://www.jisort.com/'),
  InvestmentFirm('KCB Bank Tanzania', 'https://www.kcbgroup.com/'),
  InvestmentFirm('Letshego Bank Tanzania', 'https://www.letshego.com/'),
  InvestmentFirm('Maendeleo Bank Plc', 'https://www.maendeleobank.co.tz/'),
  InvestmentFirm('Maendeleo Bank', 'https://www.maendeleobank.co.tz/'),
  InvestmentFirm('Meru Agro-Tours & Consultants', 'https://www.meruagro.co.tz/'),
  InvestmentFirm('Mkombozi Commercial Bank', 'https://www.mkombozibank.co.tz/'),
  InvestmentFirm('Mufindi Community Bank', 'https://www.mufindicb.com/'),
  InvestmentFirm('National Microfinance Bank', 'https://www.nmbbank.co.tz/'),
  InvestmentFirm('NBC Bank Tanzania', 'https://www.nbc.co.tz/'),
  InvestmentFirm('NIC Bank Tanzania', 'https://www.nicbank.co.tz/'),
  InvestmentFirm('Njombe Community Bank', 'https://www.njombebank.co.tz/'),
  InvestmentFirm('NMB Capital', 'https://www.nmbbank.co.tz/'),
  InvestmentFirm('Orbit Securities', 'https://www.orbit.co.tz/'),
  InvestmentFirm('Rafiki Microfinance Bank', 'https://www.rafikibank.co.tz/'),
  InvestmentFirm('Shelys Pharmaceuticals', 'https://www.shelyspharma.com/'),
  InvestmentFirm('Standard Bank Tanzania', 'https://www.standardbank.co.tz/'),
  InvestmentFirm('Standard Chartered Bank Tanzania', 'https://www.sc.com/tz/'),
  InvestmentFirm('Stanbic Bank Tanzania', 'https://www.stanbicbank.co.tz/'),
  InvestmentFirm('TPB Bank', 'https://www.tpbank.co.tz/'),
  InvestmentFirm('Tanzania Agricultural Development Bank', 'https://www.tadb.co.tz/'),
  InvestmentFirm('Tanzania Investment Bank', 'https://www.tib.co.tz/'),
  InvestmentFirm('Tanzania Securities Limited', 'https://www.tsl.co.tz/'),
  InvestmentFirm('TIB Development Bank', 'https://www.tib.co.tz/'),
  InvestmentFirm('TIB Rasilimali', 'https://www.tibra.co.tz/'),
  InvestmentFirm('Twiga Bancorp', 'https://www.twigabank.co.tz/'),
  InvestmentFirm('UBA Tanzania', 'https://www.ubagroup.com/'),
  InvestmentFirm('Vodacom Tanzania', 'https://www.vodacom.co.tz/'),
  InvestmentFirm('Yono Auction Mart', 'https://www.yono.co.tz/'),
  InvestmentFirm('Yetu Microfinance Bank', 'https://www.yetumfb.co.tz/'),
  InvestmentFirm('Zan Securities', 'https://www.zansec.com/'),
];
 List<InvestmentFirm> filteredFirms = [];

  @override
  void initState() {
    super.initState();
    firms.sort((a, b) => a.name.compareTo(b.name));
    filteredFirms = List.from(firms);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Investment Firms in Tanzania'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  filteredFirms = firms
                      .where((firm) =>
                          firm.name.toLowerCase().contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFirms.length,
              itemBuilder: (context, index) {
                InvestmentFirm firm = filteredFirms[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: GestureDetector(
                      child: Text(
                        firm.name,
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        // Open the website of the selected investment firm
                        launchURL(firm.website);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}