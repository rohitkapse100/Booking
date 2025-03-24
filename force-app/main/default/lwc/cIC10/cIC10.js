import { LightningElement } from 'lwc';

export default class CIC10 extends LightningElement {
    connectedCallback(){
        var a = 'HelloCIC10';
        console.log('Value of a-'+a);
        console.log('Type of a-'+typeof a);
        var a = 7;
        console.log('Value of a-'+a);
        console.log('Type of a-'+typeof a);
        var a = true;
        console.log('Value of a-'+a);
        console.log('Type of a-'+typeof a);
        if(a){
            let b = 'Hello';
            var c = 'Hello1';
        }else{

        }
        console.log('Value of c-'+c);

        var arr = [];
        arr = [1,2,3,4,5];
        console.log('arrData--'+arr[2]);
        console.log('arrData--'+arr[3]);
        for(let i=0;i<arr.length;i++){
            console.log('arrData--'+arr[i]);
        }

        var obj = {
            'Name' : 'Rohit',
            'Age': 23,
            23 : 'Age',
            'isMale': true,
            'ContactDetails' : ['9380310374','1234567'],
            'FamilyDetails' : {
                'Name': 'Mangala',
                'Relation': 'Mother'
            },
            'SiblingsDetails': [{'Name':'Dolly','Relation':'Sister'},{'Name':'Surbhi','Relation':'Sister'}
        ],
        };
        console.log('obj Name'+obj.Name);
        console.log('obj Age'+obj.Age);
        console.log('obj ContactDetails'+obj.ContactDetails[0]);
        for(let i=0;i<obj.SiblingsDetails.length;i++){
            if(obj.SiblingsDetails[i].Name=='Surbhi'){
                console.log('obj SiblingsDetails'+obj.SiblingsDetails[i].Relation);

            }
        }

    }
}