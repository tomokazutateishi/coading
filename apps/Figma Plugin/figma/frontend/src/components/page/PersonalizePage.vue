<template>
  <div>
    <PznHeader />
    <main class="personalize-main">
      <div class="personalize-main__layout">
        <aside class="personalize-main__side">
          <PznSidePanel :folders="folders" :items="sideItems" :alertMessage="sideAlert" />
        </aside>
        <section class="personalize-main__content">
          <div class="personalize-main__search-filter">
            <PznSearchBox placeholder="キーワードで検索" />
            <PznSelectBox :options="selectOptions" v-model="selectedOption" />
          </div>
          <div class="personalize-main__segmented-group">
            <PznSegmentedGroup :items="segmentedItems" v-model="selectedSegment" />
          </div>
          <PznAlert message="右上の「＋」ボタンからフォルダを作成して、よく使う帳票を振り分けておくことができます。" />
          <div class="personalize-main__card-list">
            <PznCard
              v-for="card in cards"
              :key="card.id"
              :title="card.title"
              :meta1="card.meta1"
              :meta2="card.meta2"
              :meta3="card.meta3"
              :description="card.description"
              :hasMenu="card.hasMenu"
            />
          </div>
        </section>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import PznHeader from '@/components/element/PznHeader.vue'
import PznSearchBox from '@/components/element/PznSearchBox.vue'
import PznSelectBox from '@/components/element/PznSelectBox.vue'
import PznSegmentedGroup from '@/components/element/PznSegmentedGroup.vue'
import PznCard from '@/components/element/PznCard.vue'
import PznAlert from '@/components/element/PznAlert.vue'
import PznSidePanel from '@/components/element/PznSidePanel.vue'

const selectOptions = [
  { label: '番号順', value: 'number' }
]
const selectedOption = ref('number')

const segmentedItems = [
  { label: 'App', value: 'app', icon: '🛒' },
  { label: 'Bars', value: 'bars', icon: '📊' },
  { label: 'Folder', value: 'folder', icon: '📁' },
  { label: 'User', value: 'user', icon: '👤' },
  { label: 'More', value: 'more', icon: '⋯' }
]
const selectedSegment = ref('app')

const cards = [
  { id: 1, title: 'ｺｰﾋｰ豆看貫表', meta1: '在庫業務', meta2: 'GNS', meta3: '001', description: '出庫指図の情報を呼び出すことにより、コーヒー豆の看貫表を作成します。\n指図情報は品目が03D、03H、03Iを対象にしています。', hasMenu: true },
  { id: 2, title: '運送料明細', meta1: '在庫業務', meta2: 'GNS', meta3: '002', description: '寄託者、出庫日範囲指定で、出庫時に納入を指定しているデータを抽出します。', hasMenu: true },
  { id: 3, title: '荷主品種名一覧', meta1: '在庫業務', meta2: 'GNS', meta3: '003', description: '課所/荷主指定で、荷主品種ﾃｰﾌﾞﾙに登録している内容を印刷、もしくはExcelに出力します。', hasMenu: true },
  { id: 4, title: '期間指定出庫荷役実績', meta1: '在庫業務', meta2: 'GNS', meta3: '004', description: '期間指定で寄託者別／入出庫荷役別の個数、２次個数、重量、容積の情報を抽出します。', hasMenu: true },
  { id: 5, title: '寄託価格一括変更', meta1: '在庫業務', meta2: 'GNS', meta3: '005', description: '課所、寄託者、入庫番号、入庫日等で、記入票を検索し、寄託単価/寄託価格の全量一括変更を行います。', hasMenu: true },
  { id: 6, title: '期別入出庫実績集計', meta1: '在庫業務', meta2: 'GNS', meta3: '006', description: '課所、寄託者、請求月、締日を指定する事により、個数、２次個数の期毎の入出庫実績を集計し、EXCELに出力します。', hasMenu: true }
]

const folders = [
  { id: 1, name: 'すべての帳票', selected: true },
  { id: 2, name: 'マイフォルダ' },
  { id: 3, name: 'グループ共有フォルダ' }
]
const sideItems = [
  { id: 1, name: 'フォルダ名をここに表示' },
  { id: 2, name: 'フォルダ名をここに表示' }
]
const sideAlert = '右上の「＋」ボタンからフォルダを作成して、よく使う帳票を振り分けておくことができます。'
</script>

<style scoped>
.personalize-main {
  padding: 16px;
}
.personalize-main__layout {
  display: flex;
  gap: 24px;
}
.personalize-main__side {
  min-width: 220px;
}
.personalize-main__content {
  flex: 1;
}
.personalize-main__search-filter {
  display: flex;
  gap: 16px;
  margin-bottom: 24px;
}
.personalize-main__segmented-group {
  margin-bottom: 24px;
}
.personalize-main__card-list {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-top: 24px;
}
</style>
