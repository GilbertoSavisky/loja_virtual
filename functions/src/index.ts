import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { CieloConstructor, Cielo, TransactionCreditCardRequestModel, EnumBrands, CaptureRequestModel, CancelTransactionRequestModel} from 'cielo';


admin.initializeApp(functions.config().firebase);

const merchantId = functions.config().cielo.menchantid;
const merchantKey = functions.config().cielo.menchantkey;

const cieloParams: CieloConstructor = {
  merchantId: merchantId,
  merchantKey: merchantKey,
  sandbox: true, // Opcional - Ambiente de Testes
  debug: true // Opcional - Exibe os dados enviados na requisição para a Cielo
}
const cielo = new Cielo(cieloParams);

export const authorizeCreditCard = functions.https.onCall( async (data, context) => {
  if(data === null){
    return {
      'success': false,
      'error': {
        'code': -1,
        'message': 'Dados não informados'
      }
    }
  }
  if(!context.auth){
    return {
      'success': false,
      'error': {
        'code': -1,
        'message': 'Nenhum usuário logado'
      }
    }
  }
  const userId = context.auth.uid;
  const snapshot = await admin.firestore().collection('users').doc(userId).get();
  const userData = snapshot.data() || {};

  let bandeira: EnumBrands;

  switch(data.creditCard.brand){
    case 'VISA':
      bandeira = EnumBrands.VISA;
      break;
    case 'MASTERCARD':
      bandeira = EnumBrands.MASTER;
      break;
    case 'AMEX':
      bandeira = EnumBrands.AMEX;
      break;
    case 'AURA':
      bandeira = EnumBrands.AURA;
      break;
    case 'DINERSCLUB':
      bandeira = EnumBrands.DINERS;
      break;
    case 'DISCOVER':
      bandeira = EnumBrands.DISCOVERY;
      break;
    case 'ELO':
      bandeira = EnumBrands.ELO;
      break;
    case 'HIPERCARD':
      bandeira = EnumBrands.HIPERCARD;
      break;
    case 'JCB':
      bandeira = EnumBrands.JCB;
      break;
    default:
      return {
        'success': false,
        'error': {
          'code': -1,
          'message': 'Cartão não suportado '+ data.creditCard.brand
        }
      };                                                                              
    }

    const saleData: TransactionCreditCardRequestModel = {
      merchantOrderId: data.merchantOrderId,
      customer: {
        name: userData.nome,
        identity: data.cpf,
        identityType: 'CPF',
        email: userData.email,
        deliveryAddress: {
          city: userData.endereco.cidade,
          complement: userData.endereco.complemento,
          country: 'BRA',
          district: userData.endereco.bairro,
          number: userData.endereco.numero,
          state: userData.endereco.estado,
          street: userData.endereco.rua,
          zipCode: userData.endereco.CEP.replace('.', '').replace('-', '')
        },
      },
      payment: {
        currency: 'BRL',
        country: 'BRA',
        amount: data.amount,
        installments: data.installments,
        softDescriptor: data.softDescriptor.substring(0, 13),
        type: data.paymentType,
        capture: false,
        creditCard: {
          brand: bandeira,
          cardNumber: data.creditCard.cardNumber,
          expirationDate: data.creditCard.expirationDate,
          holder: data.creditCard.holder,
          securityCode: data.creditCard.securityCode
        } 
      },
    }
   
    try {
      const transaction = await cielo.creditCard.transaction(saleData);

      if(transaction.payment.status === 1){
        return {
          'success': true,
          'paymentId': transaction.payment.paymentId,
        }
      } else {
        let mensagem = '';
        switch(transaction.payment.returnCode){
          case '5':
            mensagem = 'Não autorizado';
            break; 
          case '57':
            mensagem = 'Cartão expirado';
            break; 
          case '78':
            mensagem = 'Cartão bloqueado';
            break; 
          case '99':
            mensagem = 'Timeout';
            break; 
          case '77':
            mensagem = 'Cartão cancelado';
            break; 
          case '70':
            mensagem = 'Problemas com o cartão de crédito';
            break;
          default:
            mensagem = transaction.payment.returnMessage;
            break;
        }
        return {
          'success': false,
          'status': transaction.payment.status,
          'error': {
            'code': transaction.payment.returnCode,
            'message': mensagem
          }
        }
      }
    } catch(e){
      return {
        'success': false,
        'error': {
          'code': e.response[0].Code,
          'message': e.response[0].Message
        }
      }
    }
});

export const capturaCartaoCredito = functions.https.onCall( async (data, context) => {
  if(data === null){
    return {
      'success': false,
      'error': {
        'code': -1,
        'message': 'Dados não informados'
      }
    }
  }
  if(!context.auth){
    return {
      'success': false,
      'error': {
        'code': -1,
        'message': 'Nenhum usuário logado'
      }
    }
  }

  const capturaParams: CaptureRequestModel = {
    paymentId: data.payId,
  };

  try {
    const captura = await cielo.creditCard.captureSaleTransaction(capturaParams);

    if(captura.status == 2) {
      return {
        'success': true
      };
    }
    else {
      return {
        'success': false,
        'status': captura.status,
        'error': {
          'code': captura.returnCode,
          'message': captura.returnMessage
        }
      };
    }
  } catch(e){
    return {
      'success': false,
      'error': {
        'code': e.response[0].Code,
        'message': e.response[0].Message
      }
    }
  }
});
export const cancelarCartaoCredito = functions.https.onCall( async (data, context) => {
  if(data === null){
    return {
      'success': false,
      'error': {
        'code': -1,
        'message': 'Dados não informados'
      }
    }
  }
  if(!context.auth){
    return {
      'success': false,
      'error': {
        'code': -1,
        'message': 'Nenhum usuário logado'
      }
    }
  }

  const cancelParams: CancelTransactionRequestModel = {
    paymentId: data.payId,
  };

  try {
    const cancel = await cielo.creditCard.cancelTransaction(cancelParams);

    if(cancel.status == 10 || cancel.status == 11) {
      return {
        'success': true
      };
    }
    else {
      return {
        'success': false,
        'status': cancel.status,
        'error': {
          'code': cancel.returnCode,
          'message': cancel.returnMessage
        }
      };
    }
  } catch(e){
    return {
      'success': false,
      'error': {
        'code': e.response[0].Code,
        'message': e.response[0].Message
      }
    }
  }
});


// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
export const helloWorld = functions.https.onCall((data, context) => {
  functions.logger.info("Hello logs!", {structuredData: true});
   return {data: "Hello from Cloud_functions!"};
});

export const getUserData = functions.https.onCall(async (data, context) => {
  if(!context.auth)
    return {'data': "Nenhum usuario logado!"};
  
  const snapshot = await admin.firestore().collection('users').doc(context.auth.uid).get();
  return {'data': snapshot.data()};
});

export const addMsg = functions.https.onCall(async(data, context) => {
  console.log(data);

  const snapshot = await admin.firestore().collection('mensagens').add(data);
  return{'sucesso': snapshot.id};
});

export const novoPedido = functions.firestore.document('pedidos/{pedidoId}').onCreate( async (snapshot, context ) => {
  const pedidoId = context.params.pedidoId;
  
  const querySnapshot = await admin.firestore().collection('admins').get();

  const admins = querySnapshot.docs.map(doc => doc.id);

  let adminsTokens: string[] = [];

  for(let i =0; i < admins.length; i++){
      const tokensAdmin: string[] = await getDeviceTokens(admins[i]);
      adminsTokens = adminsTokens.concat(tokensAdmin);
  }

  await sendPushFCM(
    adminsTokens,
    'Novo Pedido',
    'Nova venda realizada. Pedido: ' + pedidoId
    )
});

const pedidoStatus = new Map([
  [0, 'Cancelado'],
  [1, 'em preparação'],
  [2, 'em transporte'],
  [3, 'entregue']
]);

export const onPedidoStatusChanged = functions.firestore.document('pedidos/{pedidoId}').onUpdate( async (snapshot, context) => {
  const statusAntes = snapshot.before.data().status;
  const statusDepois = snapshot.after.data().status;

  if(statusAntes !== statusDepois){
    const tokenUser = await getDeviceTokens(snapshot.after.data().user);

    await sendPushFCM(
      tokenUser,
      'Novo status do pedido: ' + context.params.pedidoId,
      'Status atualizado para:  ' + pedidoStatus.get(statusDepois)
    )
  }
});

async function getDeviceTokens(uid: string) {
  const querySnapshot = await admin.firestore().collection('users').doc(uid).collection('tokens').get();
  const tokens = querySnapshot.docs.map(doc => doc.id);
  return tokens;
}

async function sendPushFCM(tokens: string[], titulo: string, mensagem: string){
  if(tokens.length > 0) {
    const payload = {
      notification: {
        title: titulo,
        body: mensagem,
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };
    return admin.messaging().sendToDevice(tokens, payload);
  }
  else {
    return
  }
}