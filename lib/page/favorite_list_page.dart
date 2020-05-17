import 'package:eso/database/search_item.dart';
import 'package:eso/database/search_item_manager.dart';
import 'package:eso/ui/ui_favorite_item.dart';
import 'package:eso/page/content_page_manager.dart';
import 'package:eso/model/profile.dart';
import 'package:eso/model/favorite_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'chapter_page.dart';

class FavoriteListPage extends StatefulWidget {
  final int type;

  const FavoriteListPage({
    this.type,
    Key key,
  }) : super(key: key);

  @override
  _FavoriteListPageState createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  Widget _page;
  FavoriteListProvider __provider;

  var sortList = [
    ['收藏顺序', SortType.CREATE],
    ['更新时间', SortType.UPDATE],
    ['最后阅读', SortType.LASTREAD]
  ];

  @override
  void dispose() {
    __provider?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_page == null) {
      _page = _buildPage();
    }
    return _page;
  }

  Widget _buildPage() {
    return ChangeNotifierProvider.value(
        value: FavoriteListProvider(widget.type),
        builder: (BuildContext context, _) {
          return Consumer<FavoriteListProvider>(
              builder: (context, provider, _) {
            if (__provider == null) {
              __provider = provider;
            }
            return Column(children: [
              Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 12, bottom: 10),
                  child: Wrap(
                    spacing: 8,
                    children: sortList
                        .map(
                          (tag) => GestureDetector(
                              onTap: () => provider.sortList(tag[1]),
                              child: Material(
                                color: Theme.of(context).buttonColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                  child: Text(
                                    tag[0],
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: tag[1] == provider.sortType
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .color),
                                  ),
                                ),
                              )),
                        )
                        .toList(),
                  )),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1));
                  return;
                },
                child: _buildFavoriteGrid(__provider.searchList),
              ))
            ]);
          });
        });
  }

  Widget _buildFavoriteGrid(List<SearchItem> searchItems) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: searchItems.length > 0
            ? GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.55,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: searchItems.length,
                itemBuilder: (context, index) {
                  final searchItem = searchItems[index];
                  final longPress = Provider.of<Profile>(context, listen: false)
                      .switchLongPress;
                  VoidCallback openChapter = () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              ChapterPage(searchItem: searchItem)));
                  VoidCallback openContent = () => Navigator.of(context)
                      .push(ContentPageRoute().route(searchItem));
                  return InkWell(
                    child: UIFavoriteItem(searchItem: searchItem),
                    onTap: longPress ? openChapter : openContent,
                    onLongPress: longPress ? openContent : openChapter,
                  );
                },
              )
            : Container(
                alignment: Alignment.center,
                child: Text("￣へ￣ 还没有收藏哦！"),
              ));
  }
}