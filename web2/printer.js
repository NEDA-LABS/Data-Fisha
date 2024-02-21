function propertyOr(property, orFn) {
    return function (data) {
        return typeof data === 'object' && data !== null && data !== undefined && data.hasOwnProperty(property)
            ? data[property]
            : orFn(data);
    }
}

function propertyOrNull(property) {
    return propertyOr(property, _ => null);
}

function compose(...fns) {
    return function (...args) {
        return fns.reduceRight((res, fn) => [fn.call(null, ...res)], args)[0];
    }
}

async function directPosPrintAPI(data, qr) {
    const getPrintFunction = compose(
        propertyOrNull('print'),
        propertyOrNull('smartstock')
    );
    const printFunction = getPrintFunction(window);
    if (typeof printFunction === 'function') {
        return printFunction(data); // .then(console.log).catch(console.log);
    }
    throw {message: 'no printer method exposed'};
}


async function hasDirectPosPrinterAPI() {
    const getPrintFunction = compose(
        propertyOrNull('print'),
        propertyOrNull('smartstock')
    );
    const printFunction = getPrintFunction(window);
    return typeof printFunction === 'function';
}
