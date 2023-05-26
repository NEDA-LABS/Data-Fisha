console.log('----------------')
async function download(data,mime,filename) {
console.log('**********')
   var blob = new Blob([data], {type: mime });
   var url = URL.createObjectURL(blob);

   var a = document.createElement('a');
   a.download = `${filename}`;
   a.style = {display:'none';}
   a.href = url;
   a.click();
//   document.getElementById('body').appendChild(a);
}
